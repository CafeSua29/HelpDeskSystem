using System.ComponentModel;

namespace HelpDeskSystem.Models
{
    public class AuditTrail : SystemLog
    {
        public int Id { get; set; }

        [DisplayName("Action")]
        public string Action { get; set; }

        [DisplayName("Module")]
        public string Module { get; set; }

        [DisplayName("Affected Table")]
        public string AffectedTable { get; set; }

        [DisplayName("Time")]
        public DateTime TimeStamp { get; set; } = DateTime.Now;

        //public string IpAddress { get; set; }

        [DisplayName("User")]
        public string UserId { get; set; }

        [DisplayName("User")]
        public AppUser User { get; set; }

        [DisplayName("Old Values")]
        public string? OldValues { get; set; }

        [DisplayName("New Values")]
        public string? NewValues { get; set; }

        [DisplayName("Affected Columns")]
        public string? AffectedColumns { get; set; }

        [DisplayName("Primary Key")]
        public string? PrimaryKey { get; set; }
    }
}
