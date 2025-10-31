{ }:

rec {

  choose =
    cond: a: b:
    if cond then [ a ] else [ b ];

  optional = cond: a: builtins.concatLists (choose cond [ a ] [ ]);

}
