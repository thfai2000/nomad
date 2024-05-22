namespace _net;

class Program
{
    static void Main(string[] args)
    {
        while(true){
            Console.WriteLine("=====Hello, World!====");
            
            List<string> environmentVariableNames = new List<string>
            {
                "ENV_A",
                "ENV_B",
                "ENV_C",
                "ENV_D",
                "ENV_E",
                "ENV_F"
            };

            foreach (string variableName in environmentVariableNames)
            {
                try{
                    string variableValue = Environment.GetEnvironmentVariable(variableName);
                    Console.WriteLine($"{variableName}: {variableValue}");
                }catch(Exception ex){
                    Console.WriteLine(ex);
                }
            }

            Thread.Sleep(new TimeSpan(0, 0, 3));
        }
    }
}
