using System.ComponentModel;

namespace HelpDeskSystem.Models
{
    public class Department : UserActivity
    {
        [DisplayName("No")]
        public int Id { get; set; }

        [DisplayName("Code")]
        public string Code { get; set; }

        [DisplayName("Name")]
        public string Name { get; set; }
    }
}
