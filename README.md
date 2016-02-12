PHOTOCOP
========

# English

A mod for ![MineTest](https://minetest.net) which adds a photocopier to copy the content of written books and memorandum's written papers.
Craft ink, paper, and the machine and copy your texts to spread them.

Mod by @LeMagnesium/Mg, by an idea of hassage, with help and model by Ze_Escrobar, and turbogus.

# French

Un mod qui ajoute des photocopieuses à minetest.
Craftez encre, papier et photocopieuses et copiez vos écrits pour les publier!

Mod par Mg, selon une idée de hassage, avec l'aide de Ze_Escrobar, turbogus


# How to use
In order to copy books and/or papers you will first need to craft the photocopy machine using the following recipe :

+------------+------------+------------+
| Steelblock | Glass      | Steelblock |
+------------+------------+------------+
| Chest      | Sand tube  | Chest      |
+------------+------------+------------+
| Steelblock | Steelblock | Steelblock |
+------------+------------+------------+

Once the machine crafted and placed, you will introduce ink in the appropriate slot of its inventory. Ink is crafted thus way :

+--------------+
| Stick        |
+--------------+
| Coal lump    |
+--------------+
| Glass bottle |
+--------------+

You will get tons (precisely 50) of ink at a time, which is normal since you need one item of ink per copy. Finally, craft blank papers and place them next to the ink, and wait.
So far, the counting mechanic not being implemented, the photocopy machine will start working once : 
 * It has enough space to copy the paper in the output
 * It has enough ink and paper to do 1 copy
 * A written paper/book is placed into the machine
 
As soon as one of those conditions appear false, the machine will stop working and stay idle.

The photocopy machine currently supports :
 * Default's written books
 * Memorandum's written letters
 
Still WIP/NIY :
 * Counting mechanic to input the amount of copies required
 * More accurate way of calculating the cost in ink of a copy
 * Ink lever bar in the machine's formspec