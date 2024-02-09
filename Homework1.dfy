/* Exercise 1 (10 points)

Implement the following OCaml function as a dafny function:

let mystery_function x y z = 
  let a = x + y in
  let b = y + z in 
  let c = x + z in 
  (a+b+c) / 2
*/

function mystery_function(x:int, y:int, z:int): int {
    var a := x + y;
    var b := y + z;
    var c := x + z;
    (a + b + c) / 2
}
/* Exercise 2 (20 points)

You are given the following Dafny datatype, which is equivalent
to the following OCaml tree type:

type 'a tree = Leaf | Node of ('a * 'a tree * 'a tree)

*/

datatype Tree<T> = 
    | Leaf 
    | Node (data:T, left: Tree<T>, right:Tree<T>)

/* Implement the `map` and `fold` functions over these trees.

For reference, the OCaml definition would be:

let rec mapTree f t = 
  match t with
  | Leaf -> Leaf
  | Node (x,l,r) -> Node (f x, mapTree f l, mapTree f r)

let rec foldTree f e t = 
  match t with
  | Leaf -> e 
  | Node (x,l,r) -> f x (foldTree f e l) (foldTree f e r)

Here is the stub for map:

*/

function fold<A, B>(f: (A -> B -> B -> B) -> B, t: Tree<A>): B
  decreases t
{
    match t
    case Leaf => 
        f(\a b c => b)
    case Node(v, left, right) =>
        let leftFold := fold(f, left);
        let rightFold := fold(f, right);
        f(\a b c => a(v, leftFold, rightFold))
}

function mapTree<A,B> (f: A -> B, t: Tree<A>): Tree<B>
  decreases t
{
    match t
    case Leaf => 
        Leaf
    case Node(v, left, right) =>
        Node(f(v), mapTree(f, left), mapTree(f, right))
}

/* Fill in your own template for fold, with the same argument order as the OCaml code. */

/* Exercise 3 (20 points)

You are given the following MapSet wrapper arround Dafny's maps, which
fixes the type of the "values" to be booleans. As a result,
one can think of a MapSet as a set, where an element is considered
to be in the MapSet iff it maps to true in the wrapped map.

Implement the following set API calls in terms of this 
wrapper, by invoking Dafny map functions as seen on the slides.

*/

datatype MapSet<T> = MapSet (s : map<T,bool>)

predicate member<T>(m: MapSet<T>, x: T) 
{
    m.s[x] == true
}

function size<T>(m: MapSet<T>): int 
{
    |m.s|
}

function insert<T>(m: MapSet<T>, x: T): MapSet<T> 
{
    MapSet(m.s[x := true])
}

function delete<T>(m: MapSet<T>, x: T): MapSet<T> 
{
    MapSet(m.s[x := false])
}
