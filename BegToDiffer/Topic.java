import java.util.ArrayList;
import java.util.Collections;

/**
 * The Topic class.
 * 
 * Represents a topic that contains a number of words and articles.
 * 
 * @author Tanner Smith and Ryan Ashcraft
 */
public class Topic {
	private String name;
	private ArrayList<Word> topWords = new ArrayList<Word>();
	private ArrayList<Article> articles = new ArrayList<Article>();
	
	/**
	 * Constructs a new Topic with a name and basis article.
	 * @param name Name of topic.
	 * @param basis Initial article to add.
	 */
	public Topic(String name, Article basis)
	{
		this.name = name;
		add(basis);
	}
	
	/**
	 * Add an article to this topic.
	 * @param article Article to be added.
	 */
	public void add(Article article)
	{
		articles.add(article);
		addTopWords(article);
	}
	
	/**
	 * Add the top words from an article to the top words of the topic.
	 * @param article Article to add top words from.
	 */
	public void addTopWords(Article article)
	{
		ArrayList<Word> articleTopWords = article.getOverallTopWords();
		
		//Add as many words within the article's top words or as many we're allowed to by the constant.
		for (int i = 0; (i < Main.MAX_WORDS_FOR_TOPICS && i < articleTopWords.size()); i++)
		{
			Word word = articleTopWords.get(i);
			//If the word already exists, increment its value. If not, add it.
			if (topWords.contains(word))
			{
				Word thisWord = topWords.get(topWords.indexOf(word));
				thisWord.setValue(thisWord.getValue() + word.getValue());
			} else {
				topWords.add(word);
			}
		}
	}
	
	/**
	 * Gets the candidate percentage that an article should be added to this topic.
	 * @param article Article to be compared to this topic.
	 * @return Percentage from 0.00 to 1.00 on how much the given article is like this topic.
	 */
	public double getCandidatePercentage(Article article)
	{
		double numerator = 0;
		double totalOccurances = 0;
		
		ArrayList<Word> articleTopWords = article.getOverallTopWords();
		
		System.out.println("Topic: "+name+"\nArticle in Question: "+article.getTitle());
		System.out.println("Article Top Words: "+articleTopWords);
		Collections.sort(topWords);
		System.out.println("Topic Top Words: "+topWords);
		
		for (Word word : topWords)
		{
			totalOccurances += word.getValue();
		}
		
		for (int i = 0; (i < Main.MAX_WORDS_FOR_TOPICS && i < articleTopWords.size()); i++)
		{
			Word word = articleTopWords.get(i);
			if (topWords.contains(word))
			{
				Word thisWord = topWords.get(topWords.indexOf(word));
				numerator++;
			}
		}
		
		double result = numerator / Main.MAX_WORDS_FOR_TOPICS;
		System.out.println("Result: "+result+" ("+((result > Main.MIN_PERCENTAGE_FOR_TOPIC_ADD) ? "passed" : "failed")+")\n-----");
		return result;
	}
	
	/**
	 * Get the name.
	 * @return Name of the topic.
	 */
	public String getName()
	{
		return name;
	}
	
	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	public String toString()
	{
		return "Topic \""+name+"\": "+articles.size();//+"\nTopic Top Words: "+topWords+"\nArticles:\n"+articles+"\n\n";
		//return "Topic \""+name+"\": "+articles+"\nTop Words: "+topWords;
	}
}