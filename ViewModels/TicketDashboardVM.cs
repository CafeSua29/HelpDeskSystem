using HelpDeskSystem.Models;

namespace HelpDeskSystem.ViewModels
{
    public class TicketDashboardVM
    {
        public TicketsSummaryView TicketsSummary { get; set; }

        public TicketsPriorityView TicketsPriority { get; set; }
    }
}
