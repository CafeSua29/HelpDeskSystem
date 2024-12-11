
using DocumentFormat.OpenXml.Spreadsheet;

namespace HelpDeskSystem.Models
{
    public class Vote
    {
        public int Id { get; set; }

        public string UserId { get; set; }

        public AppUser User { get; set; }

        public int CommentId { get; set; }

        public Comment Comment { get; set; }

        public int Value { get; set; }
    }
}
