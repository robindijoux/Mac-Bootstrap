# Mac Bootstrap

Script d'installation automatisé pour configurer un Mac de développement avec les outils IA modernes.

## Outils installés

- **Homebrew** — Gestionnaire de paquets macOS
- **Git** — Contrôle de version
- **OpenCode** — Agent de coding IA en terminal
- **OhMyOpenCode** — Plugin d'orchestration pour OpenCode (agents, MCPs, hooks)
- **Zed** — Éditeur de code multi-joueur avec IA intégrée

## Utilisation

```bash
# Clone ce repo (ou télécharge juste le script)
git clone https://github.com/votre-user/Mac-Bootstrap.git
cd Mac-Bootstrap

# Lance l'installation
./bootstrap.sh
```

Le script est idempotent : il vérifie si chaque outil est déjà installé avant de passer à l'étape suivante.

## Après l'installation

Redémarre ton terminal ou exécute :

```bash
source ~/.zprofile
```

### Lancer OpenCode avec OhMyOpenCode

```bash
cd ton-projet
opencode
```

### Lancer Zed

```bash
zed .
```

## Compatibilité

- macOS Intel (x86_64)
- macOS Apple Silicon (ARM64)

## Licence

MIT
