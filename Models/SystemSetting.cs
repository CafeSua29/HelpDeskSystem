using System.ComponentModel;

namespace HelpDeskSystem.Models
{
    public class SystemSetting : UserActivity
    {
        public int Id { get; set; }

        [DisplayName("Code")]
        public string Code { get; set; }

        [DisplayName("Name")]
        public string Name { get; set; }

        [DisplayName("Value")]
        public int Value { get; set; }
    }
}
