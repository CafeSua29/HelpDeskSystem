using System.ComponentModel;
using System.Runtime.CompilerServices;

namespace HelpDeskSystem.Models
{
    public class SystemCode : UserActivity
    {
        public int Id { get; set; }

        [DisplayName("Code")]
        public string Code { get; set; }

        [DisplayName("Description")]
        public string Description { get; set; }
    }
}
