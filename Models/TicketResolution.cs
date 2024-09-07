using System.ComponentModel;

namespace HelpDeskSystem.Models
{
    public class TicketResolution : UserActivity
    {
        [DisplayName("No")]
        public int Id { get; set; }

        public int TicketId { get; set; }

        public Ticket Ticket { get; set; }

        [DisplayName("Description")]
        public string Description { get; set; }

        [DisplayName("Status")]
        public int StatusId { get; set; }

        public SystemCodeDetail Status { get; set; }
    }
}
