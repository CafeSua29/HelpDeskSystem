namespace HelpDeskSystem.Models
{
    public class SystemSetting : UserActivity
    {
        public int Id { get; set; }

        public string Code { get; set; }

        public string Name { get; set; }

        public int Value { get; set; }
    }
}
