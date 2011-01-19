import java.util.ArrayList;

public class Topic {
	private String name;
	private ArrayList<Word> topWords = new ArrayList<Word>();
	private ArrayList<Article> articles = new ArrayList<Article>();
	
	public Topic(String name, Article basis)
	{
		this.name = name;
		add(basis);
	}
	
	public void add(Article article)
	{
		articles.add(article);
		addTopWords(article);
	}
	
	public void addTopWords(Article article)
	{
		ArrayList<Word> articleTopWords = article.getOverallTopWords();
		for (int i = 0; (i < Main.NUM_TOP_WORDS_FOR_TOPICS && i < articleTopWords.size()); i++)
		{
			Word word = articleTopWords.get(i);
			if (topWords.contains(word))
			{
				Word thisWord = topWords.get(topWords.indexOf(word));
				thisWord.setValue(thisWord.getValue() + word.getValue());
			} else {
				topWords.add(word);
			}
		}
	}
	
	public double getCandidatePercentage(Article article)
	{
		double numerator = 0;
		double totalOccurances = 0;
		
		ArrayList<Word> articleTopWords = article.getOverallTopWords();
		
		System.out.println("Topic: "+name+"\nArticle in Question: "+article.getTitle());
		System.out.println("Article Top Words: "+articleTopWords);
		System.out.println("Topic Top Words: "+topWords);
		
		for (Word word : topWords)
		{
			totalOccurances += word.getValue();
		}
		
		for (int i = 0; (i < Main.NUM_TOP_WORDS_FOR_TOPICS && i < articleTopWords.size()); i++)
		{
			Word word = articleTopWords.get(i);
			if (topWords.contains(word))
			{
				Word thisWord = topWords.get(topWords.indexOf(word));
				numerator += (thisWord.getValue() + word.getValue()) / 2;
			}
		}
		//System.out.println("Numerator: "+numerator+" Total Occurances: "+totalOccurances);
		
		double result = numerator / (totalOccurances / articles.size());
		System.out.println("Result: "+result+" ("+((result > Main.MIN_PERCENTAGE_FOR_TOPIC_ADD) ? "passed" : "failed")+")\n-----");
		return result;
	}
	
	public String getName()
	{
		return name;
	}
	
	public String toString()
	{
		return "Topic \""+name+"\": "+articles.size();//+"\nTopic Top Words: "+topWords+"\nArticles:\n"+articles+"\n\n";
		//return "Topic \""+name+"\": "+articles+"\nTop Words: "+topWords;
	}
}