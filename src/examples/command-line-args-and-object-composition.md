---
title: "Example: Command line arguments and object composition"
---

```csharp
using System;
using System.Collections.Generic;

namespace example
{
  class Program
  {
    // All this code assumes that the program is run with
    // a single command line argument on the following form:
    // "John Doe;Jane Doe;Johnny Dodo" etc
    static void Main(string[] args)
    {
      // Instantiate people parser by passing the correct
      // command line argument.
      PeopleParser parser = new PeopleParser(args[0]);

      // Extract people from input data by running parser.
      List<Person> people = parser.Parse();

      // Print all people to screen.
      foreach (Person p in people)
        Console.WriteLine(p.AsString());
    }
  }

  class PeopleParser
  {
    // Private instance variable.
    string[] parts;

    // Constructor.
    public PeopleParser (string data)
    {
      // Split the input data into its constituent parts
      // and assign the result to an instance variable.
      this.parts = data.Split(";");
    }

    // Public instance method.
    public List<Person> Parse ()
    {
      List<Person> people = new List<Person>();
      foreach (string person in this.parts)
      {
        PersonParser parser = new PersonParser(person);
        people.Add(parser.Parse());
      }
      return people;
    }
  }

  class PersonParser
  {
    // Private instance variable.
    string[] parts;

    // Constructor.
    public PersonParser (string data)
    {
      Console.WriteLine("PERSON: " + data);
      this.parts = data.Split(" ");
    }

    // Public instance method.
    public Person Parse ()
    {
      // Extract parts from input data.
      string firstName = this.parts[0];
      string lastName = this.parts[1];
      // Build name object.
      Name name = new Name(firstName, lastName);
      // Build and return person object.
      return new Person(name);
    }
  }

  class Person
  {
    // Private instance variable
    Name name;

    // Constructor.
    public Person (Name name)
    {
      this.name = name;
    }

    // Instance method.
    public string AsString ()
    {
      // String interpolation
      return $"({this.name.AsString()}) :: Person";
    }
  }

  class Name
  {
    // Properties that are publicly readable but not writeable.
    public string First { get; private set; }
    public string Last { get; private set; }

    // Constructor.
    public Name (string first, string last)
    {
      this.First = first;
      this.Last = last;
    }

    // Instance method.
    public string AsString ()
    {
      // String interpolation.
      return $"({this.First}, {this.Last}) :: Name";
    }
  }
}
```
