
1. Subtype and parametric polymorphism
    1. Skapa ett nytt `interface` som du kallar för `INum` som tar en typparameter.
    1. Definiera metoderna `Inc`, `Dec`, `Sub`, `Add` i `INum` och ge metoderna samma signaturer som motsvarande metoder i `Nat` och `NatPair`.
    1. Låt både `Nat` och `NatPair` implementera interface:et `INum`.
    1. Skapa en ny klass som heter `Calculator`.
    1. Skapa en instansmetod i `Calculator` som heter `Inc`. Metoden ska ta ett argument av typen `INum` och returnera ett resultat av typen `INum`. Metoden ska incrementera talet som passas in och returnera
    HMM MUTATION????
    1. Skapa en instansmetod i `Calculator` som heter `Mult`. Metoden ska ta två argument av typen `INum` och returnera någonting av typen `INum`. Metoden ska multiplicera det ena talet med det andra genom att använda sig 
    1. TODO IS SUB EVEN DEFINED?
    1. TODO (`Nat : Num` and `NatPair : Num`)

1. Overriding
    1. TODO (`ToString`)

1. Abstract classes (subtype polymorphism)
    1. TODO

1. Class inheritance (subtype polymorphism)
    1. TODO

1. Generics (parametric polymorphism)
    1. TODO (`Pair<Nat>` instead of `NatPair`)

1. Immutability and recursion
    1. TODO (Nat returns new nat instead of mutating)
    1. TODO (Church numerals now requires recursion)
