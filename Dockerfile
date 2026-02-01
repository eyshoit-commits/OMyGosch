FROM ghcr.io/chriswritescode-dev/opencode-manager:0.8.21

USER root

RUN mkdir -p /opt/app && \
    cp -r /app/* /opt/app/ 2>/dev/null || true && \
    chown -R root:root /opt/app

# Benutzer bkg erstellen, falls nicht vorhanden
RUN id -u bkg >/dev/null 2>&1 || useradd -m -s /bin/bash bkg

# User node entfernen, falls vorhanden
RUN userdel -r node 2>/dev/null || true

# System-Abhängigkeiten
RUN apt-get update \
    && apt-get install -y curl wget git build-essential libssl-dev sudo \
    && echo 'bkg ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    # Miniconda installieren
    && wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -b -p /opt/conda \
    && rm /tmp/miniconda.sh \
    && ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh \
    && echo ". /opt/conda/etc/profile.d/conda.sh" >> /etc/bash.bashrc \
    && echo "conda activate base" >> /etc/bash.bashrc \
    # nvm & Node LTS installieren
    && su - bkg -c "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash" \
    && su - bkg -c "export NVM_DIR=\"/home/bkg/.nvm\" && . \"/home/bkg/.nvm/nvm.sh\" && nvm install --lts" \
    # Rust installieren
    && su - bkg -c "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y" \
    # Clean up
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# PATH erweitern
ENV NODE_ENV=production
ENV HOST=0.0.0.0
ENV PORT=5003
ENV OPENCODE_SERVER_PORT=5551
ENV DATABASE_PATH=/opt/app/data/opencode.db
ENV WORKSPACE_PATH=/home/bkg/workspace
ENV PATH="/opt/conda/bin:/home/bkg/.cargo/bin:$PATH"
ENV CONDA_AUTO_ACTIVATE_BASE=false

COPY pnpm-workspace.yaml /home/bkg/workspace/
COPY docs/SETUP.MD /home/bkg/workspace/docs/SETUP.MD
COPY package.json /home/bkg/workspace/
COPY quick-start.sh /home/bkg/workspace/
COPY setup-environment.sh /home/bkg/workspace/
COPY .gitignore /home/bkg/workspace/
COPY .opencode /home/bkg/workspace/.opencode
COPY scripts /opt/app/scripts
COPY scripts/generate-openapi.ts /home/bkg/workspace/scripts/generate-openapi.ts

RUN mkdir -p /opt/app/backend/node_modules/@opencode-manager && \
    rm -f /opt/app/backend/node_modules/@opencode-manager/shared && \
    ln -s /opt/app/shared /opt/app/backend/node_modules/@opencode-manager/shared

COPY scripts/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

RUN mkdir -p /home/bkg/workspace && \
    chown -R bkg:bkg /home/bkg/workspace /opt/app/data /opt/app/scripts

EXPOSE 5003 5100 5101 5102 5103

HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:5003/api/health || exit 1

USER bkg

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["bun", "backend/src/index.ts"]