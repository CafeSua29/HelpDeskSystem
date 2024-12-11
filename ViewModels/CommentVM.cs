using HelpDeskSystem.Models;

namespace HelpDeskSystem.ViewModels
{
    public class CommentVM
    {
        public Comment Comment { get; set; }

        public List<Comment> Replies { get; set; }

        public int Depth { get; set; }

        public string UserId { get; set; }

        public bool isAdmin { get; set; }

        public int? CurrentUserVote { get; set; }
    }
}
