namespace Cuyahoga.Modules.Articles
{
	using System;
	using System.Collections;
	using System.Drawing;
	using System.Web;
	using System.Web.UI.WebControls;
	using System.Web.UI.HtmlControls;
	using System.Text.RegularExpressions;

	using Cuyahoga.Core.Util;
	using Cuyahoga.Core.Domain;
	using Cuyahoga.Web.UI;
	using Cuyahoga.Web.Util;
	using Cuyahoga.Modules.Articles;

	/// <summary>
	///		Summary description for Articles.
	/// </summary>
	public partial class Articles : BaseModuleControl
	{
		private ArticleModule _module;
		private Article _activeArticle;
		private bool _allowComments;
		private bool _allowAnonymousComments;
		private int _numberOfArticlesInList;
		private bool _allowSyndication;


		protected void Page_Load(object sender, System.EventArgs e)
		{
			this._module = this.Module as ArticleModule;
			if (this.Module.Section.Settings["ALLOW_SYNDICATION"] != null)
			{
				this._allowSyndication = Boolean.Parse(this.Module.Section.Settings["ALLOW_SYNDICATION"].ToString());
			}
			// Don't display the syndication icon on the article view
			base.DisplaySyndicationIcon = this._allowSyndication && this._module.CurrentArticleId == -1;

			if (this._module != null && (! base.HasCachedOutput || this.Page.IsPostBack) || this.Page.User.Identity.IsAuthenticated)
			{
				// Custom settings
				this._allowComments = Boolean.Parse(this.Module.Section.Settings["ALLOW_COMMENTS"].ToString());
				this._allowAnonymousComments = Boolean.Parse(this.Module.Section.Settings["ALLOW_ANONYMOUS_COMMENTS"].ToString());
				this._numberOfArticlesInList = Int32.Parse(this.Module.Section.Settings["NUMBER_OF_ARTICLES_IN_LIST"].ToString());

				if (this._module.CurrentArticleId > 0)
				{
					// Article view
					this._activeArticle = this._module.GetArticleById(this._module.CurrentArticleId);
					this.litTitle.Text = this._activeArticle.Title;
					this.litContent.Text = this._activeArticle.Content;

					this.hplBack.NavigateUrl = UrlHelper.GetUrlFromSection(this._module.Section);
					this.hplBack.Text = base.GetText("BACK");
					this.btnSaveComment.Text = base.GetText("BTNSAVECOMMENT");
					this.rfvName.ErrorMessage = base.GetText("NAMEREQUIRED");
					this.rfvComment.ErrorMessage = base.GetText("COMMENTREQUIRED");

					this.pnlArticleDetails.Visible = true;
					this.pnlComments.Visible = this._allowComments && this._activeArticle.Comments.Count > 0;
					if (this._allowAnonymousComments || (this.Page.User.Identity.IsAuthenticated && this._allowComments))
					{
						this.pnlComment.Visible = true;
						this.pnlAnonymous.Visible = (! this.Page.User.Identity.IsAuthenticated);
					}
					else
					{
						this.pnlComment.Visible = false;
					}
					// Comments
					this.rptComments.DataSource = this._activeArticle.Comments;
					this.rptComments.ItemDataBound += new RepeaterItemEventHandler(rptComments_ItemDataBound);
					this.rptComments.DataBind();
				}
				else if (this._module.CurrentCategoryId > 0)
				{
					// Category view
					this.rptArticles.ItemDataBound += new RepeaterItemEventHandler(rptArticles_ItemDataBound);
					this.rptArticles.DataSource = this._module.GetDisplayArticlesByCategory(); // ArticleModule knows its currentCategoryId.
					this.rptArticles.DataBind();
					this.pnlArticleList.Visible = true;
					if (this.rptArticles.Items.Count > 0)
					{
						// HACK: Get the name of the category from the first article in the list.
						Article firstArticle = ((IList)this.rptArticles.DataSource)[0] as Article;
						base.Module.DisplayTitle = base.GetText("CATEGORY") + " " + firstArticle.Category.Title;
					}
				}
				else
				{
					// Article list view
					int numberOfArticles = 10; // default 
					if (this._module.Section.Settings["NUMBER_OF_ARTICLES_IN_LIST"] != null)
					{
						numberOfArticles = Int32.Parse(this._module.Section.Settings["NUMBER_OF_ARTICLES_IN_LIST"].ToString());
					}
					this.rptArticles.ItemDataBound += new RepeaterItemEventHandler(rptArticles_ItemDataBound);
					this.rptArticles.DataSource = this._module.GetDisplayArticles(numberOfArticles);
					this.rptArticles.DataBind();
					this.pnlArticleList.Visible = true;
				}
			}
		}

		private string GetProfileUrl(int userId)
		{
			Section sectionTo = this._module.Section.Connections["ViewProfile"] as Section;
			if (sectionTo != null)
			{
				return UrlHelper.GetUrlFromSection(sectionTo) + "/ViewProfile/" + userId.ToString();
			}
			else
			{
				// for backward compatibility
				return this.Page.ResolveUrl(String.Format("~/Profile.aspx/view/{0}", userId));
			}
		}

		#region Web Form Designer generated code
		override protected void OnInit(EventArgs e)
		{
			//
			// CODEGEN: This call is required by the ASP.NET Web Form Designer.
			//
			InitializeComponent();
			base.OnInit(e);
		}
		
		/// <summary>
		///		Required method for Designer support - do not modify
		///		the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{

		}
		#endregion

		private void rptArticles_ItemDataBound(object sender, RepeaterItemEventArgs e)
		{
			if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
			{
				Article article = e.Item.DataItem as Article;

				HyperLink hpl = e.Item.FindControl("hplTitle") as HyperLink;
				hpl.NavigateUrl = UrlHelper.GetUrlFromSection(this._module.Section) + "/" + article.Id;

				Literal litDateOnline = e.Item.FindControl("litDateOnline") as Literal;
				litDateOnline.Text = 
					TimeZoneUtil.AdjustDateToUserTimeZone(article.DateOnline, this.Page.User.Identity).ToLongDateString();
				HyperLink hplAuthor = e.Item.FindControl("hplAuthor") as HyperLink;
				hplAuthor.NavigateUrl = GetProfileUrl(article.CreatedBy.Id);
				hplAuthor.Text = article.CreatedBy.FullName;

				HyperLink hplCategory = e.Item.FindControl("hplCategory") as HyperLink;
				if (article.Category != null)
				{
					hplCategory.NavigateUrl = UrlHelper.GetUrlFromSection(this.Module.Section) + 
						String.Format("/category/{0}", article.Category.Id);
					hplCategory.Text = article.Category.Title;
				}
				else
				{
					hplCategory.Text = "-";
				}

				HyperLink hplComments = e.Item.FindControl("hplComments") as HyperLink;
				if (this._allowComments)
				{
					hplComments.NavigateUrl = UrlHelper.GetUrlFromSection(this._module.Section) 
						+ String.Format("/{0}#comments", article.Id);
					hplComments.Text = base.GetText("COMMENTS") + " " + article.Comments.Count.ToString();
				}
				else
				{
					hplComments.Visible = false;
				}
				Panel pnlSummary = e.Item.FindControl("pnlSummary") as Panel;
				Panel pnlContent = e.Item.FindControl("pnlContent") as Panel;
				DisplayType displayType = (DisplayType)Enum.Parse(typeof(DisplayType), this._module.Section.Settings["DISPLAY_TYPE"].ToString());
				pnlSummary.Visible = (displayType == DisplayType.HeadersAndSummary);
				pnlContent.Visible = (displayType == DisplayType.FullContent);
			}
		}

		protected void btnSaveComment_Click(object sender, System.EventArgs e)
		{
			if (this.Page.IsValid)
			{
				// Strip any html tags.
				string commentText = Regex.Replace(this.txtComment.Text, @"<(.|\n)*?>", string.Empty);
				// Replace carriage returns with <br/>.
				commentText = commentText.Replace("\r", "<br/>");
				// Save comment.
				Comment comment = new Comment();
				comment.Article = this._activeArticle;
				comment.CommentText = commentText;
				comment.UserIp = HttpContext.Current.Request.UserHostAddress;
				if (this.Page.User.Identity.IsAuthenticated)
				{
					comment.User = this.Page.User.Identity as Cuyahoga.Core.Domain.User;
				}
				else
				{
					comment.Name = this.txtName.Text;
					comment.Website = this.txtWebsite.Text;
				}
				try
				{
					this._module.SaveComment(comment);
					// Clear the cache, so the comment will appear immediately.
					base.InvalidateCache();
					Context.Response.Redirect(UrlHelper.GetUrlFromSection(this._module.Section) + "/" + this._activeArticle.Id.ToString());
				}
				catch (Exception ex)
				{
					this.lblError.Text = ex.Message;
					this.lblError.Visible = true;
				}
			}
		}

		private void rptComments_ItemDataBound(object sender, RepeaterItemEventArgs e)
		{
			PlaceHolder plhCommentBy = e.Item.FindControl("plhCommentBy") as PlaceHolder;
			if (plhCommentBy != null)
			{
				Comment comment = (Comment)e.Item.DataItem;
				Literal litUpdateTimestamp = e.Item.FindControl("litUpdateTimestamp") as Literal;
				litUpdateTimestamp.Text = TimeZoneUtil.AdjustDateToUserTimeZone(comment.UpdateTimestamp, this.Page.User.Identity).ToString();

				if (comment.User != null)
				{
					// Comment by registered user.
					if (comment.User.Website != null && comment.User.Website != String.Empty)
					{
						HyperLink hpl = new HyperLink();
						hpl.NavigateUrl = GetProfileUrl(comment.User.Id);
						hpl.Text = comment.User.FullName;
						plhCommentBy.Controls.Add(hpl);
					}
					else
					{
						Literal lit = new Literal();
						lit.Text = comment.User.FullName;
						plhCommentBy.Controls.Add(lit);
					}
				}
				else
				{
					// Comment by unregistered user.
					if (comment.Website != null && comment.Website != String.Empty)
					{
						HyperLink hpl = new HyperLink();
						hpl.NavigateUrl = comment.Website;
						hpl.Target = "_blank";
						hpl.Text = comment.Name;
						plhCommentBy.Controls.Add(hpl);
					}
					else
					{
						Literal lit = new Literal();
						lit.Text = comment.Name;
						plhCommentBy.Controls.Add(lit);
					}
				}
			}
		}
	}
}
