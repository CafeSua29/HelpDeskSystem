using System.ComponentModel;

namespace HelpDeskSystem.Models
{
    public class SystemCodeDetail : UserActivity
    {
        public int Id { get; set; }

        [DisplayName("Code")]
        public string Code { get; set; }

        [DisplayName("Description")]
        public string Description { get; set; }

        [DisplayName("Order")]
        public int? OrderNo { get; set; }

        [DisplayName("System Code")]
        public int SystemCodeId { get; set; }

        [DisplayName("System Code")]
        public SystemCode SystemCode { get; set; }
    }
}
