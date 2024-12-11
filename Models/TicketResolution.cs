using HelpDeskSystem.Helper;
using System.ComponentModel;

namespace HelpDeskSystem.Models
{
    public class TicketResolution : UserActivity
    {
        [DisplayName("No")]
        public int Id { get; set; }

        [DisplayName("Ticket")]
        public int TicketId { get; set; }

        [DisplayName("Ticket")]
        public Ticket Ticket { get; set; }

        [DisplayName("Description")]
        public string Description { get; set; }

        [DisplayName("Status")]
        public int StatusId { get; set; }

        [DisplayName("Status")]
        public SystemCodeDetail Status { get; set; }

        public string ParsedContent
        {
            get
            {
                return CommentHelper.ConvertLinks(Description);
            }
        }
    }
}
