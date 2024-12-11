using HelpDeskSystem.Models;

namespace HelpDeskSystem.ViewModels
{
    public class CommentVoteVM
    {
        public Comment Comment { get; set; }

        public int? CurrentUserVote { get; set; }
    }
}
