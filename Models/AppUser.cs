using Microsoft.AspNetCore.Identity;

namespace HelpDeskSystem.Models
{
    public class AppUser : IdentityUser
    {
        public string Name { get; set; }

        public DateOnly DOB { get; set; }

        public string Gender { get; set; }

        public DateTime? DelTime { get; set; }

        public string? Note { get; set; }
    }
}
