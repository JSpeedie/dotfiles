# Vim Cheatsheet

* `gJ` : Join the line below with the current line, but don't add a space in
  between the contents of the two lines.

* `<C-w>[hjkl]`: Go to the split to the left, below, above, or to the right.
* `<C-w>=`: Equalize the size of all the splits in the current tab.
* `gt` and `gT`: Go to the next tab, go to the previous tab.

* `gq` : Format the given motion or selection. I like to use `V` to select a
  couple lines I wish to format/fit and then use `gq` to get them under the
  line length constraint.

* `gv` : Reselect the most recent selection.

* `zz` : Move the view so the line the cursor is on is verticalled centered.
* `zt` : Move the view so the line the cursor is at the top of the screen.
* `zb` : Move the view so the line the cursor is at the bottom of the screen.

* `za` : Toggles whether the fold you are currently in is open or closed.
* `zr` : Open all folds in the file.
* `zr` : Closes all folds in the file.

* `''` : Reverse the previous jump/perform the previous jump. Essentially
  toggles between undoing the most recent jump and redoing the most recent
  jump. Useful for jumping between two locations in a file, but limited in that
  it only ever spans 1 jump.
* `<C-o>`: Move one jump back in the jump history. Super useful. `<C-o>` to
  return to the file you were in after using `gf` to jump into a file is a common
  use for this. `<C-o>` is also useful when `''` is too limited.
* `<C-i>`: Go to the location where the most recent jump ended. The counterpart
  to `<C-o>`, useful for jumping between files or navigating the jump list.
