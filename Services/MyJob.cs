namespace HelpDeskSystem.Services
{
    public class MyJob
    {
        public Type Type { get; set; }

        public string Expression { get; set; }

        public MyJob(Type type, string expression)
        {
            Type = type;
            Expression = expression;
        }
    }
}
