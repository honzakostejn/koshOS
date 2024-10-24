# AGS
If you've just cloned the repo, you'll be probably be missing TypeScript types. Since the configuration of AGS is handled by home-manager, this might require the following commands to be ran.

```bash
# it is expected that you use AGS V2 from this flake!
# remove any existing configuration if it exists
rm -rf ~/.config/ags

# generate the types
ags --generate

# copy the generated types to the config directory
mv ~/.config/ags/@girs ~/koshos/home/honzakostejn/programs/ags

# remove everything again, so that the configuration can be managed by home-manager
rm -rf ~/.config/ags
```

I believe that this is just a temporary solution, until AGS V2 is properly merged and documented, so people like me can just follow documentaiton instead of bruteforcing it.