using HelpDeskSystem.Models;
using System.ComponentModel;

namespace HelpDeskSystem.ViewModels
{
    public class RoleVM : UserActivity
    {
        [DisplayName("Role No")]
        public string Id { get; set; }

        [DisplayName("Name")]
        public string Name { get; set; }
    }
}
