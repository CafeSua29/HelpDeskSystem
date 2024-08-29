namespace HelpDeskSystem.Models
{
    public class Comment
    {
        public int Id { get; set; }

        public string Description { get; set; }

        public int TicketId { get; set; }

        public Ticket Ticket { get; set; }

        public string CreatedById { get; set; }

        public AppUser CreatedBy { get; set; }

        public DateTime CreatedOn { get; set; }

        public DateTime? DelTime { get; set; }

        public string? Note { get; set; }
    }
}
