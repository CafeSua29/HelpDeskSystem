using System.ComponentModel;

namespace HelpDeskSystem.Models
{
    public class TicketsSummaryView
    {
        [DisplayName("Total Tickets")]
        public int TotalTickets { get; set; }

        [DisplayName("Assigned Tickets")]
        public int AssignedTickets { get; set; }

        [DisplayName("Pending Tickets")]
        public int PendingTickets { get; set; }

        [DisplayName("Resolved Tickets")]
        public int ResolvedTickets { get; set; }

        [DisplayName("Closed Tickets")]
        public int ClosedTickets { get; set; }
    }
}
