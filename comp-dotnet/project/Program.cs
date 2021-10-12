using System;

namespace HelloWorld
{
    class Program
    {
        static void Main(string[] args)
        {
            var c1 = new MyClass();
            var ip = "10.10.0.1";  // hardcoded stuff
            Console.WriteLine($"Hello World! {c1.ReturnMessage()}");
        }
    }
}