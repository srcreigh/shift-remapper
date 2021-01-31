# shift-remapper
Remap shift layer with Karabiner Elements

```sh
racket generate.rkt > programmers_dvorak.json && ./install.sh programmers_dvorak.json
```

Edit `config` to tweak the remapped characters.

Keys on the shift layer must be specified in `unshift-map`, or you can't remap them.

Some characters must be converted to the correct [Karabiner keycode](https://github.com/pqrs-org/Karabiner-Elements/issues/925#issuecomment-323984568) in `->keycode`.
