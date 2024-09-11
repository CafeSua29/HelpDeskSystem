using Microsoft.AspNetCore.Identity;
using System.ComponentModel;

namespace HelpDeskSystem.Models
{
    public class AppUser : IdentityUser
    {
        public string Name { get; set; }

        public DateOnly DOB { get; set; }

        public string Gender { get; set; }

        [DisplayName("Created By")]
        public string? CreatedById { get; set; }

        [DisplayName("Created By")]
        public AppUser? CreatedBy { get; set; }

        [DisplayName("Created On")]
        public DateTime CreatedOn { get; set; }

        [DisplayName("Modified By")]
        public string? ModifiedById { get; set; }

        [DisplayName("Modified By")]
        public AppUser? ModifiedBy { get; set; }

        [DisplayName("Modified On")]
        public DateTime? ModifiedOn { get; set; }

        public DateTime? DelTime { get; set; }

        public string? Note { get; set; }
    }
}
