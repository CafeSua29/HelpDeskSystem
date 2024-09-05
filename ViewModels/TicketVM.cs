using HelpDeskSystem.Models;
using System.ComponentModel;

namespace HelpDeskSystem.ViewModels
{
    public class TicketVM : UserActivity
    {
        public Ticket Ticket { get; set; }

        [DisplayName("Comments")]
        public int Comments { get; set; }
    }
}
