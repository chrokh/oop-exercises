---
title: Exercise: natural numbers
---

<div class="warning">
*Detta dokument är under konstruktion och kommer att förändras över kommande dagar. Använd på egen risk :)*
</div>

1. Klasser, instansvariabler, och konstruktorer
    1. Skapa en klass som heter `Nat`. Ordet "nat" används här för att föra tankarna till den naturliga talserien ([natural numbers](https://en.wikipedia.org/wiki/Natural_number)) där nästa tal alltid är 1 större än föregående. I den definition vi använder här så börjar de "naturliga" talen på 1 och de "hela" talen på 0.
    1. Deklarera en instansvariabel i klassen `Nat`. Instansvariabeln ska heta `x`, ha typen `int` och dess access modifier ska vara `private`.
    1. Skapa en konstruktor utan parametrar i klassen `Nat`. Konstruktorn ska sätta instansvariabeln `x` till det hårdkodade värdet 1. Vi väljer detta eftersom 1 är det lägsta naturliga talet.
    1. Skapa en till konstruktor i klassen `Nat` som tar en parameter av typen `int`. Du väljer själv vad denna variabel ska heta. Tilldela instansvariabeln `x` detta värde.
    1. Varför är det problematiskt att vi försöker representera naturliga tal med datatypen `int`? Tips: tänk på vilka värden de olika datatyperna tillåter.

1. Instansmetoder, statiska metoder, och objekt
    1. Skapa en publik instansmetod i klassen `Nat` som heter `Print`. Metoden ska inte ta några parametrar och inte heller returnera någonting. Vad gäller implementationen så ska metoden skriva ut värdet som finns lagrat i `x` konkatenerat med strängen `" :: Nat"`. Skriv ut till skärmen genom att använda `WriteLine`. Om `x` t.ex. innehåller 5 så ska vi alltså skriva ut `"5 :: Nat"`.
    1. Varför kan metoden `Print` inte vara en statisk (`static`) metod?
    1. Instantiera klassen `Nat` två gånger utanför `Nat` (t.ex. i din main entry point) och lagra de två objekten i två variabler som du kallar `n1` respektive `n2`. Det första objektet ska instantieras genom `Nat`-konstruktorn som inte tar några parametrar, medan den andra ska instantieras genom den konstruktorn som förväntar sig en `int`. Välj själv vilket positivt heltal (större än noll) du ska ge `n2`.
    1. Anropa instansmetoden `Print` för både `n1` och `n2` så att deras meddelanden skrivs ut på skärmen.
    1. Kör programmet. Skriver objekten ut samma sak? Varför?

1. Coupling och cohesion
    1. Skriv om instansmetoden `Print` i `Nat`-klassen så att den returnerar en `string` istället för att printa direkt till skärmen.
    1. Varför printas inte längre någonting när vi nu kör programmet?
    1. Hur har `Nat`-klassens dependencies förändrats nu när vi inte längre anropar `WriteLine` direkt i `Nat`?
    1. Printa (genom `WriteLine`) de två strängarna som returneras av de två naturliga talen (`n1` och `n2`) när vi i vår main entry point anropar `Print`.
    1. På vilka sätt skulle detta sätt att printa kunna vara bättre än det föregående? Tips: tänk på begreppen coupling och cohesion.

1. Instansmetoder och mutation
    1. Skapa en publik instansmetod i klassen `Nat` som heter `Inc`. Metoden ska inte ta några parametrar och inte heller returnera någonting. Metodens implementation är helt enkelt att instansvariabeln `x` inkrementeras med 1.
    1. Skapa en publik instansmetod i klassen `Nat` som heter `Dec`. Metoden ska inte ta några parametrar och inte heller returnera någonting. Metodens implementation är att instansvariabeln `x` dekrementeras med 1, men endast ifall det resulterande talet är större än 0.
    1. Varför vill vi inte att `x` ska kunna dekrementeras till ett tal som är lägre än 1?
    1. Vad menas när vi säger att metoderna `Inc` och `Dec` "muterar" instanser av `Nat`?
    1. Vad menas när vi säger att metoderna `Inc` och `Dec` inte är "pure"?
    1. Är `Nat` en "immutable" eller "mutable" datatyp? Varför?

1. Objekt som parametrar
    1. Skapa en publik instansmetod i klassen `Nat` som heter `Add`. Metoden ska ta en parameter av typen `Nat` men inte returnera någonting. Metoden ska addera innehållet i de två naturliga talen och sätta `x` till det uträknade värdet.
    1. Anropa instansmetoden `Add` på `n1` och skicka `n2` som argument.
    1. Printa efter detta ut både `n1` och `n2` genom att anropa `Print` och skicka resultatet till `WriteLine`.
    1. Varför har bara värdet i `n1` förändrats?

1. Exceptions
    1. Låt konstruktorn som tar ett argument kasta ett exception (t.ex. `ArgumentException`) om den `int` som den tar emot är lägre än 1.
    1. Vad hade vi kunnat göra istället för att kasta ett exception om vi blir givna ett tal lägre än 1?

1. Object composition
    1. Skapa en ny klass som heter `NatPair`. Klassen ska innehålla två privata instansvariabler av typen `Nat` vars värde tilldelas genom två parametrar i konstruktorn.
    1. Skapa en publik instansmetod i `NatPair` som heter `Sum`. Metoden tar inga argument, returnerar en `Nat` och räknar ut denna int genom att summera de två instansvariablerna och returnera resultatet.
    1. Skapa en publik instansmetod i klassen `NatPair` som heter `Inc`. Metoden ska inte ta några parametrar och inte heller returnera någonting. Metoden inkrementerar båda de underliggande instansvariablerna av typ `Nat`.
    1. Skapa en publik instansmetod i klassen `NatPair` som heter `Dec`. Metoden ska inte ta några parametrar och inte heller returnera någonting. Metoden dekrementerar båda de underliggande instansvariablerna.
    1. Skapa en publik instansmetod i klassen `NatPair` som heter `Add`. Metoden tar en parameter av typen `Nat` men returnerar ingenting. Metoden adderar det inpassade objektet av typen `Nat` till de båda instansvariablerna av typen `Nat`.

1. Overriding
    1. TODO (`ToString`)

1. Interfaces (subtype polymorphism)
    1. TODO (`Nat : Num` and `NatPair : Num`)

1. Abstract classes (subtype polymorphism)
    1. TODO

1. Class inheritance (subtype polymorphism)
    1. TODO

1. Generics (parametric polymorphism)
    1. TODO (`Pair<Nat>` instead of `NatPair`)

1. Immutability and recursion
    1. TODO (Nat returns new nat instead of mutating)
    1. TODO (Church numerals now requires recursion)
