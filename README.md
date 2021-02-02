# shift-remapper
Remap shift layer with Karabiner Elements.

Edit `config` in `generate.rkt` to tweak the character mapping.

To install the config run this command:

```sh
racket generate.rkt > programmers_dvorak.json && ./install.sh programmers_dvorak.json
```

Enable it in Karabiner Elements by going to Complex Rules > Add Rule > (your rule name).

Keys on the shift layer must be specified in `unshift-map`, or you can't remap them.

Some characters must be converted to the correct [Karabiner keycode](https://github.com/pqrs-org/Karabiner-Elements/issues/925#issuecomment-323984568) in `->keycode`.

This doesn't affect keyboard shortcuts that use modifiers. For example, the `=` key pressed alone may generate `+`, but `Cmd-=` will still send `Cmd-=`.
