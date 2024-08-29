namespace HelpDeskSystem.Models
{
    public class Ticket
    {
        public int Id { get; set; }

        public string Title { get; set; }

        public string Description { get; set; }

        public string Status { get; set; }

        public string Priority { get; set; }

        public string CreatedById { get; set; }

        public AppUser CreatedBy { get; set; }

        public DateTime CreatedOn { get; set; }

        public DateTime? DelTime { get; set; }

        public string? Note { get; set; }
    }
}
