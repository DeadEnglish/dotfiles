# Dot files

> [!NOTE]
> This is currently mac only & is still a very much WIP. Whilst stable and working, I'm constantly updating so it's subject to change. See below for known issues

## installation

1. Clone this repo to your the following location `~/.config`

2. Run the below command to install everything required (see below if you face any issues)
```bash
$ bash setup.sh
```

### Known issues
- [ ] the default `.zshrc` file created by omzsh does not direct to the custom file in `/zsh-custom/.zshrc.config`, you will need to manually add this into the file
- [ ] When running the initial `setup.sh`, brew may require some commands to be run before brew can be properly found.
- [ ] Simillarly above, the `post-setup.sh` file does not run correctly as `nvm` may not be sourced correctly.
