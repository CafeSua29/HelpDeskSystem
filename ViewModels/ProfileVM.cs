using HelpDeskSystem.Models;
using Microsoft.AspNetCore.Identity;
using System.ComponentModel;

namespace HelpDeskSystem.ViewModels
{
    public class ProfileVM
    {
        public ICollection<SystemTask> SystemTasks { get; set; }

        public ICollection<AppRole> SystemRoles { get; set; }

        public ICollection<int> RightsIdAssigned { get; set; }

        public int[] Ids { get; set; }

        [DisplayName("System Role")]
        public string RoleId { get; set; }

        [DisplayName("Role name")]
        public string RoleName { get; set; }

        [DisplayName("System Task")]
        public int TaskId { get; set; }
    }
}
