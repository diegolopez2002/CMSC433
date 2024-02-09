/* Exercise 1 (10 points)

Implement the following OCaml function as a dafny function:

let mystery_function x y z = 
  let a = x + y in
  let b = y + z in 
  let c = x + z in 
  (a+b+c) / 2
*/

function mystery_function(x: int, y: int, z: int): int
{
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

function method mapTree<A,B>(f: A -> B, t: Tree<A>): Tree<B>
{
    match t
    {
        case Leaf => Leaf
        case Node(data, left, right) =>
            Node(f(data), mapTree(f, left), mapTree(f, right))
    }
}

method foldTree<T, R>(f: (T, R, R) -> R, e: R, t: Tree<T>) returns (res: R)
{
    match t
    {
        case Leaf => res := e;
        case Node(data, left, right) =>
            var leftFolded: R := foldTree(f, e, left);
            var rightFolded: R := foldTree(f, e, right);
            res := f(data, leftFolded, rightFolded);
    }
}


/* Exercise 3 (20 points)

You are given the following MapSet wrapper arround Dafny's maps, which
fixes the type of the "values" to be booleans. As a result,
one can think of a MapSet as a set, where an element is considered
to be in the MapSet iff it maps to true in the wrapped map.

Implement the following set API calls in terms of this 
wrapper, by invoking Dafny map functions as seen on the slides.

*/

datatype MapSet<T> = MapSet (s : map<T,bool>)

predicate member<T> (m: MapSet<T>, x: T) {
    m.s[x]
}

function method size<T>(m: MapSet<T>): nat {
    |set x | x in m.s && m.s[x]|
}

function insert<T> (m: MapSet<T>, x: T): MapSet<T> {
    MapSet(m.s[x := true])
}

function delete<T> (m: MapSet<T>, x: T): MapSet<T> {

    MapSet(m.s[x := false])
}
