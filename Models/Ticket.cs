using System.ComponentModel;

namespace HelpDeskSystem.Models
{
    public class Ticket : UserActivity
    {
        [DisplayName("No")]
        public int Id { get; set; }

        [DisplayName("Title")]
        public string Title { get; set; }

        [DisplayName("Description")]
        public string Description { get; set; }

        [DisplayName("Status")]
        public int StatusId { get; set; }

        [DisplayName("Status")]
        public SystemCodeDetail Status { get; set; }

        [DisplayName("Priority")]
        public int PriorityId { get; set; }

        [DisplayName("Priority")]
        public SystemCodeDetail Priority { get; set; }

        [DisplayName("Attachment")]
        public string? Attachment { get; set; }

        [DisplayName("Category")]
        public int SubCategoryId { get; set; }

        [DisplayName("Category")]
        public TicketSubCategory SubCategory { get; set; }

        [DisplayName("Assigned To")]
        public string? AssignedToId { get; set; }

        [DisplayName("Assigned To")]
        public AppUser? AssignedTo { get; set; }

        [DisplayName("Assigned On")]
        public DateTime? AssignedOn { get; set; }

        [DisplayName("Duration")]
        public int? Duration
        {
            get
            {
                if (CreatedOn == null)
                    return null;

                DateTime now = DateTime.UtcNow;

                TimeSpan difference = now.Subtract(CreatedOn);

                return difference.Days;
            }
        }
    }
}
