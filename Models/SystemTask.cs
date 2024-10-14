using System.ComponentModel;

namespace HelpDeskSystem.Models
{
    public class SystemTask : UserActivity
    {
        public int Id { get; set; }

        [DisplayName("Parent")]
        public int? ParentId { get; set; }

        [DisplayName("Parent")]
        public SystemTask? Parent { get; set; }

        [DisplayName("Code")]
        public string Code { get; set; }

        [DisplayName("Name")]
        public string Name { get; set; }

        [DisplayName("Child Tasks")]
        public ICollection<SystemTask>? ChildTasks { get; set; }

        [DisplayName("Order")]
        public int? OrderNo { get; set; }
    }
}
