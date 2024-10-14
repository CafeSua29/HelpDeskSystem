using System.ComponentModel;

namespace HelpDeskSystem.Models
{
    public class TicketSubCategory : UserActivity
    {
        public int Id { get; set; }

        [DisplayName("Category")]
        public int CategoryId { get; set; }

        [DisplayName("Category")]
        public TicketCategory Category { get; set; }

        [DisplayName("Code")]
        public string Code { get; set; }

        [DisplayName("Name")]
        public string Name { get; set; }
    }
}
