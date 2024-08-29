namespace HelpDeskSystem.Models
{
    public class AuditTrail
    {
        public int Id { get; set; }

        public string Action { get; set; }

        public string Module { get; set; }

        public string AffectedTable { get; set; }

        public DateTime TimeStamp { get; set; } = DateTime.Now;

        public string IpAddress { get; set; }

        public string UserId { get; set; }

        public AppUser User { get; set; }

        public string? OldValues { get; set; }

        public string? NewValues { get; set; }

        public string? AffectedColumns { get; set; }

        public DateTime? DelTime { get; set; }

        public string? Note { get; set; }
    }
}
