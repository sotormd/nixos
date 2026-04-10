{
  # it is impossible for any string to hash to "!"
  # this locks the root account
  users.users.root.hashedPassword = "!";
}
