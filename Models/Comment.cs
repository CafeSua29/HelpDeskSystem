using System.ComponentModel;

namespace HelpDeskSystem.Models
{
    public class Comment : UserActivity
    {
        public int Id { get; set; }

        [DisplayName("Description")]
        public string Description { get; set; }

        [DisplayName("Ticket")]
        public int TicketId { get; set; }

        [DisplayName("Ticket")]
        public Ticket Ticket { get; set; }
    }
}
