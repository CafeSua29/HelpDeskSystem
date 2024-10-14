using System.ComponentModel;

namespace HelpDeskSystem.Models
{
    public class TicketsPriorityView
    {
        [DisplayName("Total Tickets")]
        public int TotalTickets { get; set; }

        [DisplayName("Low Priority Tickets")]
        public int LowTickets { get; set; }

        [DisplayName("Medium Priority Tickets")]
        public int MediumTickets { get; set; }

        [DisplayName("High Priority Tickets")]
        public int HighTickets { get; set; }
    }
}
