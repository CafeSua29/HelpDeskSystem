using Microsoft.AspNetCore.Identity;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace HelpDeskSystem.Models
{
    public class UserRoleProfile : UserActivity
    {
        public int Id { get; set; }

        [DisplayName("System Task")]
        public int TaskId { get; set; }

        [DisplayName("System Task")]
        public SystemTask Task { get; set; }

        [DisplayName("System Role")]
        public string RoleId { get; set; }

        [DisplayName("System Role")]
        public IdentityRole Role { get; set; }
    }
}
