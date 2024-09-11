namespace HelpDeskSystem.Models
{
    public class Comment : UserActivity
    {
        public int Id { get; set; }

        public string Description { get; set; }

        public int TicketId { get; set; }

        public Ticket Ticket { get; set; }
    }
}
