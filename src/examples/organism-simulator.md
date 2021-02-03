---
title: "Organism simulator"
---

```csharp
using System;
using System.Threading;
using System.Collections.Generic;

namespace Organisms
{
  class Program
  {
    static void Main(string[] args)
    {
      int STEPS = 100;
      int ORGANISMS = 25;
      int NODES = 36;
      int REPS = 10;

      ISimFactory simFactory = new MultiSimFactory()
        .Add(new RepSimFactory(REPS, new SimFactory(new LineNodeFactory(new Random(1)))))
        .Add(new RepSimFactory(REPS, new SimFactory(new TorusNodeFactory(new Random(1)))));

      ISim sim = simFactory.Make(NODES);
      sim.Spawn(ORGANISMS);

      VisualRunner vs = new VisualRunner(sim);
      vs.Run(STEPS);
    }
  }

  interface ISimFactory
  {
    ISim Make (int nodes);
  }

  class SimFactory : ISimFactory
  {
    INodeFactory factory;

    public SimFactory (INodeFactory factory)
    {
      this.factory = factory;
    }

    public ISim Make (int nodes)
    {
      return new Sim(nodes, factory);
    }
  }

  class RepSimFactory : ISimFactory
  {
    ISimFactory factory;
    int copies;

    public RepSimFactory (int copies, ISimFactory factory)
    {
      this.copies = copies;
      this.factory = factory;
    }

    public ISim Make (int nodes)
    {
      List<ISim> sims = new List<ISim>();
      for (int i=0; i<copies; i++)
        sims.Add(factory.Make(nodes));
      return new MultiSim(sims);
    }
  }

  class MultiSimFactory : ISimFactory
  {
    ICollection<ISimFactory> factories = new List<ISimFactory>();

    public MultiSimFactory () {}
    public MultiSimFactory (ICollection<ISimFactory> factories)
    {
      this.factories = factories;
    }

    public MultiSimFactory Add (ISimFactory factory)
    {
      factories.Add(factory);
      return this;
    }

    public ISim Make (int nodes)
    {
      List<ISim> sims = new List<ISim>();
      foreach (ISimFactory factory in factories)
        sims.Add(factory.Make(nodes));
      return new MultiSim(sims);
    }
  }

  interface IRunner
  {
    void Run (int n);
  }

  class VisualRunner : IRunner
  {
    ISim sim;

    public VisualRunner (ISim sim)
    {
      this.sim = sim;
    }

    public void Run (int n)
    {
      if (n >= 0)
      {
        step();
        Thread.Sleep(50);
        Run(n - 1);
      }
    }

    private void step ()
    {
      Console.Clear();
      foreach (SimState state in sim.State())
        Console.WriteLine(stateToString(state));
      sim.Step();
    }

    private string stateToString (SimState state)
    {
      string str = "";
      for (int i=0; i<state.Nodes; i++)
      {
        int count = state.AliveOrganismsAtNode(i).Count;
        str += count > 0 ? $"{count.ToString()}" : "-";
      }
      return str + $" ({state.CountAlive()}/{state.Count()})";
    }
  }

  class MultiSim : ISim
  {
    IEnumerable<ISim> sims;

    public MultiSim (IEnumerable<ISim> sims)
    {
      this.sims = sims;
    }

    public void Spawn (int n)
    {
      foreach (ISim sim in sims)
        sim.Spawn(n);
    }

    public void Step ()
    {
      foreach (ISim sim in sims)
        sim.Step();
    }

    public IEnumerable<SimState> State ()
    {
      List<SimState> states = new List<SimState>();
      foreach (ISim sim in sims)
        foreach (SimState state in sim.State())
          states.Add(state);
      return states;
    }
  }

  interface INode
  {
    void Move ();
    int Idx ();
  }

  interface INodeFactory
  {
    INode NewNode (int nodes);
  }

  class TorusNodeFactory : INodeFactory
  {
    Random rng;

    public TorusNodeFactory (Random rng)
    {
      this.rng = rng;
    }

    public INode NewNode (int nodes)
    {
      if (Math.Sqrt(nodes) % 1 != 0)
        throw new ArgumentException("Not valid 2D Torus length.");
      int width = (int)Math.Sqrt(nodes);
      int height = (int)Math.Sqrt(nodes);
      int x = rng.Next(1, width);
      int y = rng.Next(1, height);
      return new TorusNode(x, y, width, height, rng);
    }
  }

  class TorusNode : INode
  {
    int x, y, xLim, yLim;
    Random rng;

    public TorusNode (int x, int y, int xLim, int yLim, Random rng)
    {
      this.x = x;
      this.y = y;
      this.xLim = xLim;
      this.yLim = yLim;
      this.rng = rng;
    }

    public void Move ()
    {
      // Generate new position
      int newX = x + rng.Next(-1, 1);
      int newY = y + rng.Next(-1, 1);
      // Make move and delimit to network
      x = newX % xLim >= 0 ? newX % xLim : newX % xLim + xLim;
      y = newY % yLim >= 0 ? newY % yLim : newY % yLim + yLim;
    }

    public int Idx ()
    {
      return x + 1 + y * xLim;
    }
  }

  class LineNodeFactory : INodeFactory
  {
    Random rng;

    public LineNodeFactory (Random rng)
    {
      this.rng = rng;
    }

    public INode NewNode (int nodes)
    {
      return new LineNode(rng.Next(0, nodes), nodes, rng);
    }
  }

  class LineNode : INode
  {
    int x, xLim;
    Random rng;

    public LineNode (int x, int xLim, Random rng)
    {
      this.x = x;
      this.xLim = xLim;
      this.rng = rng;
    }

    public void Move ()
    {
      // This is not a 1D torus so the line does not "wrap".
      this.x += rng.Next(-1, 1);
      if (this.x > xLim - 1) this.x = xLim -1;
      if (this.x < 0) this.x = 0;
    }

    public int Idx ()
    {
      return x;
    }
  }

  class SimState
  {
    public int Nodes { get; set; }
    ICollection<Organism> organisms;

    public SimState (int nodes, ICollection<Organism> organisms)
    {
      Nodes = nodes;
      this.organisms = organisms;
    }

    public int Count ()
    {
      return organisms.Count;
    }

    public int CountAlive ()
    {
      int count = 0;
      foreach (Organism o in organisms)
        if (o.Alive) count++;
      return count;
    }

    public ICollection<Organism> AliveOrganismsAtNode (int idx)
    {
      List<Organism> matches = new List<Organism>();
      foreach (Organism o in organisms)
        if (o.Alive && o.Pos() == idx)
          matches.Add(o);
      return matches;
    }
  }

  interface ISim
  {
    void Spawn (int n);
    void Step ();
    IEnumerable<SimState> State ();
  }

  class Sim : ISim
  {
    protected List<Organism> organisms = new List<Organism>();
    INodeFactory factory;
    int nodes;

    public Sim (int nodes, INodeFactory factory)
    {
      this.nodes = nodes;
      this.factory = factory;
    }

    public void Spawn (int n)
    {
      for (int x=0; x<n; x++)
        Spawn();
    }

    public void Spawn ()
    {
      organisms.Add(new Organism(factory.NewNode(nodes)));
    }

    public IEnumerable<SimState> State ()
    {
      return new List<SimState> ()
      {
        new SimState(nodes, organisms)
      };
    }

    public virtual void Step ()
    {
      move();
      meet();
    }

    private void move ()
    {
      foreach (Organism o in organisms)
        o.Move();
    }

    private void meet ()
    {
      foreach (Organism o1 in organisms)
        foreach (Organism o2 in organisms)
          o1.Meet(o2);
    }
  }

  class Organism
  {
    public bool Awake { get; private set; }
    public bool Alive { get; private set; }
    public int Size { get; private set; }
    INode node;

    public Organism (INode node)
    {
      this.Size = 1;
      this.Awake = true;
      this.Alive = true;
      this.node = node;
    }

    public void Move ()
    {
      if (Alive)
      {
        Awake = true; // Reset awakeness
        node.Move();
      }
    }

    public void Meet (Organism other)
    {
      bool notSame = this != other;
      bool bothAlive = this.Alive && other.Alive;
      bool sameIdx = this.node.Idx() == other.node.Idx();
      if (Awake && notSame && bothAlive && sameIdx)
      {
        if (Size >= other.Size || !other.Awake)
        {
          Size += other.Size;
          Awake = false;
          other.Alive = false;
        }
      }
    }

    public int Pos ()
    {
      return this.node.Idx();
    }
  }
}
```
