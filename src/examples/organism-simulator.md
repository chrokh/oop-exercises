---
title: "Organism simulator [work in progress]"
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
      MultiSim ms = new MultiSim(10, 36, new List<INodeFactory>(){
          new LineNodeFactory(new Random(1)),
          new TorusNodeFactory(new Random(1)),
        });

      ms.Spawn(8);

      int n = 50;
      for (int i=0; i<n; i++)
      {
        Console.Clear();
        Console.WriteLine(ms.StateString());
        ms.Step();
        Thread.Sleep(50);
      }
    }
  }

  class MultiSim
  {
    List<List<Sim>> sims = new List<List<Sim>>();

    public MultiSim (int iterations, int nodes, List<INodeFactory> factories)
    {
      foreach (INodeFactory f in factories)
      {
        sims.Add(new List<Sim>());
        for (int i=0; i<iterations; i++)
        {
          sims[sims.Count-1].Add(new Sim(nodes, f));
        }
      }
    }

    public void Spawn (int n)
    {
      foreach (var iterations in sims)
        foreach (var sim in iterations)
          for (int x=0; x<n; x++)
            sim.Spawn();
    }

    public void Step ()
    {
      foreach (var iterations in sims)
        foreach (var sim in iterations)
          sim.Step();
    }

    public string OrgStateString ()
    {
      string str = "";
      foreach (var iterations in sims)
        foreach (var sim in iterations)
          str += sim.OrgStateString();
      return str;
    }

    public string StateString ()
    {
      string str = "";
      foreach (var iterations in sims)
      {
        int sum = 0;
        for (int i=0; i<iterations.Count; i++)
        {
          str += $"[{i}]: {iterations[i].StateString()}\r\n";
          sum += iterations[i].CountAlive();
        }
        str += $"Avg alive: {sum / iterations.Count}\r\n\r\n";
      }
      return str;
    }
  }

  interface INode
  {
    void Move ();
    int Idx ();
  }

  interface INodeFactory
  {
    INode NewNode (int numNodes);
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
      int width = nodes / 2;
      int height = nodes / 2;
      int x = rng.Next(0, width);
      int y = rng.Next(0, height);
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

  class Sim
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

    public virtual void Step ()
    {
      move();
      meet();
    }

    public void Run (int n)
    {
      for (int i=0; i<n; i++)
        Step();
    }

    public int CountAlive ()
    {
      int count = 0;
      foreach (Organism o in organisms)
        if (o.Alive) count++;
      return count;
    }

    public string StateString ()
    {
      string str = "";
      for (int i=0; i<nodes; i++)
      {
        int count = AliveOrganismsAtNode(i).Count;
        if (count > 0)
          str += $"{count.ToString()}";
        else
          str += "-";
      }
      return str + $" ({CountAlive()}/{organisms.Count})";
    }

    public string OrgStateString ()
    {
      string str = "";
      foreach (Organism org in organisms)
        str += org.StateString() + "\r\n";
      return str;
    }

    public List<Organism> AliveOrganismsAtNode (int idx)
    {
      List<Organism> matches = new List<Organism>();
      foreach (Organism o in organisms)
        if (o.Alive && o.Pos() == idx)
          matches.Add(o);
      return matches;
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

    public string StateString ()
    {
      return $"Alive: {Alive},\tAwake: {Awake},\tSize: {Size},\tPos: {Pos()}";
    }
  }
}
```
