using System.ComponentModel;

namespace HelpDeskSystem.Models
{
    public class Ticket
    {
        [DisplayName("No")]
        public int Id { get; set; }

        [DisplayName("Title")]
        public string Title { get; set; }

        [DisplayName("Description")]
        public string Description { get; set; }

        [DisplayName("Status")]
        public int StatusId { get; set; }

        public SystemCodeDetail Status { get; set; }

        [DisplayName("Priority")]
        public int PriorityId { get; set; }

        public SystemCodeDetail Priority { get; set; }

        [DisplayName("Attachment")]
        public string? Attachment { get; set; }

        [DisplayName("Created By")]
        public string CreatedById { get; set; }

        public AppUser CreatedBy { get; set; }

        [DisplayName("Created On")]
        public DateTime CreatedOn { get; set; }

        [DisplayName("Ticket Sub-Category")]
        public int SubCategoryId { get; set; }

        public TicketSubCategory SubCategory { get; set; }

        [DisplayName("Assigned To")]
        public string? AssignedToId { get; set; }

        public AppUser AssignedTo { get; set; }

        [DisplayName("Assigned On")]
        public DateTime? AssignedOn { get; set; }

        public DateTime? DelTime { get; set; }

        public string? Note { get; set; }
    }
}
