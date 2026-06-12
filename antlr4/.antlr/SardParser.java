// Generated from d:\\lab\\pascal\\sard\\antlr4\\Sard.g4 by ANTLR 4.9.2
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.misc.*;
import org.antlr.v4.runtime.tree.*;
import java.util.List;
import java.util.Iterator;
import java.util.ArrayList;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class SardParser extends Parser {
	static { RuntimeMetaData.checkVersion("4.9.2", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		AND=1, OR=2, NOT=3, MOD=4, TRUE=5, FALSE=6, TILDETILDE=7, TYPEEQ=8, NEQ=9, 
		NNEQ=10, LTE=11, GTE=12, INC=13, DEC=14, PLUS_ASSIGN=15, MINUS_ASSIGN=16, 
		PREPROCESSOR=17, PLUS=18, MINUS=19, STAR=20, SLASH=21, CARET=22, PERCENT=23, 
		AMPERSAND=24, BAR=25, BANG=26, TILDE=27, AT=28, EQ=29, LT=30, GT=31, LPAREN=32, 
		RPAREN=33, LBRACE=34, RBRACE=35, LBRACKET=36, RBRACKET=37, COLON=38, SEMI=39, 
		COMMA=40, DOT=41, CURRENCY_LITERAL=42, COLOR_LITERAL=43, HEX_LITERAL=44, 
		NUMBER_LITERAL=45, INTEGER_LITERAL=46, ESCAPE_SEQ=47, STRING_LITERAL=48, 
		IDENTIFIER=49, LINE_COMMENT=50, BLOCK_COMMENT=51, WS=52;
	public static final int
		RULE_program = 0, RULE_statement = 1, RULE_declaration = 2, RULE_type = 3, 
		RULE_parameterList = 4, RULE_assignment = 5, RULE_lvalue = 6, RULE_returnStatement = 7, 
		RULE_block = 8, RULE_expression = 9, RULE_logicalOrExpr = 10, RULE_logicalAndExpr = 11, 
		RULE_comparisonExpr = 12, RULE_typeCheckExpr = 13, RULE_additiveExpr = 14, 
		RULE_multiplicativeExpr = 15, RULE_powerExpr = 16, RULE_unaryExpr = 17, 
		RULE_postfixExpr = 18, RULE_postfixLink = 19, RULE_argumentList = 20, 
		RULE_namedBlock = 21, RULE_primaryExpr = 22, RULE_literal = 23, RULE_arrayLiteral = 24;
	private static String[] makeRuleNames() {
		return new String[] {
			"program", "statement", "declaration", "type", "parameterList", "assignment", 
			"lvalue", "returnStatement", "block", "expression", "logicalOrExpr", 
			"logicalAndExpr", "comparisonExpr", "typeCheckExpr", "additiveExpr", 
			"multiplicativeExpr", "powerExpr", "unaryExpr", "postfixExpr", "postfixLink", 
			"argumentList", "namedBlock", "primaryExpr", "literal", "arrayLiteral"
		};
	}
	public static final String[] ruleNames = makeRuleNames();

	private static String[] makeLiteralNames() {
		return new String[] {
			null, "'and'", "'or'", "'not'", "'mod'", "'true'", "'false'", "'~~'", 
			"'=='", "'<>'", "'!='", "'<='", "'>='", "'++'", "'--'", "'+='", "'-='", 
			null, "'+'", "'-'", "'*'", "'/'", "'^'", "'%'", "'&'", "'|'", "'!'", 
			"'~'", "'@'", "'='", "'<'", "'>'", "'('", "')'", "'{'", "'}'", "'['", 
			"']'", "':'", "';'", "','", "'.'"
		};
	}
	private static final String[] _LITERAL_NAMES = makeLiteralNames();
	private static String[] makeSymbolicNames() {
		return new String[] {
			null, "AND", "OR", "NOT", "MOD", "TRUE", "FALSE", "TILDETILDE", "TYPEEQ", 
			"NEQ", "NNEQ", "LTE", "GTE", "INC", "DEC", "PLUS_ASSIGN", "MINUS_ASSIGN", 
			"PREPROCESSOR", "PLUS", "MINUS", "STAR", "SLASH", "CARET", "PERCENT", 
			"AMPERSAND", "BAR", "BANG", "TILDE", "AT", "EQ", "LT", "GT", "LPAREN", 
			"RPAREN", "LBRACE", "RBRACE", "LBRACKET", "RBRACKET", "COLON", "SEMI", 
			"COMMA", "DOT", "CURRENCY_LITERAL", "COLOR_LITERAL", "HEX_LITERAL", "NUMBER_LITERAL", 
			"INTEGER_LITERAL", "ESCAPE_SEQ", "STRING_LITERAL", "IDENTIFIER", "LINE_COMMENT", 
			"BLOCK_COMMENT", "WS"
		};
	}
	private static final String[] _SYMBOLIC_NAMES = makeSymbolicNames();
	public static final Vocabulary VOCABULARY = new VocabularyImpl(_LITERAL_NAMES, _SYMBOLIC_NAMES);

	/**
	 * @deprecated Use {@link #VOCABULARY} instead.
	 */
	@Deprecated
	public static final String[] tokenNames;
	static {
		tokenNames = new String[_SYMBOLIC_NAMES.length];
		for (int i = 0; i < tokenNames.length; i++) {
			tokenNames[i] = VOCABULARY.getLiteralName(i);
			if (tokenNames[i] == null) {
				tokenNames[i] = VOCABULARY.getSymbolicName(i);
			}

			if (tokenNames[i] == null) {
				tokenNames[i] = "<INVALID>";
			}
		}
	}

	@Override
	@Deprecated
	public String[] getTokenNames() {
		return tokenNames;
	}

	@Override

	public Vocabulary getVocabulary() {
		return VOCABULARY;
	}

	@Override
	public String getGrammarFileName() { return "Sard.g4"; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public ATN getATN() { return _ATN; }

	public SardParser(TokenStream input) {
		super(input);
		_interp = new ParserATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}

	public static class ProgramContext extends ParserRuleContext {
		public TerminalNode EOF() { return getToken(SardParser.EOF, 0); }
		public List<StatementContext> statement() {
			return getRuleContexts(StatementContext.class);
		}
		public StatementContext statement(int i) {
			return getRuleContext(StatementContext.class,i);
		}
		public ProgramContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_program; }
	}

	public final ProgramContext program() throws RecognitionException {
		ProgramContext _localctx = new ProgramContext(_ctx, getState());
		enterRule(_localctx, 0, RULE_program);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(53);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << NOT) | (1L << TRUE) | (1L << FALSE) | (1L << TILDETILDE) | (1L << INC) | (1L << DEC) | (1L << PLUS) | (1L << MINUS) | (1L << BANG) | (1L << TILDE) | (1L << AT) | (1L << EQ) | (1L << LPAREN) | (1L << LBRACE) | (1L << LBRACKET) | (1L << SEMI) | (1L << CURRENCY_LITERAL) | (1L << COLOR_LITERAL) | (1L << HEX_LITERAL) | (1L << NUMBER_LITERAL) | (1L << INTEGER_LITERAL) | (1L << ESCAPE_SEQ) | (1L << STRING_LITERAL) | (1L << IDENTIFIER))) != 0)) {
				{
				{
				setState(50);
				statement();
				}
				}
				setState(55);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(56);
			match(EOF);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class StatementContext extends ParserRuleContext {
		public DeclarationContext declaration() {
			return getRuleContext(DeclarationContext.class,0);
		}
		public TerminalNode SEMI() { return getToken(SardParser.SEMI, 0); }
		public AssignmentContext assignment() {
			return getRuleContext(AssignmentContext.class,0);
		}
		public ReturnStatementContext returnStatement() {
			return getRuleContext(ReturnStatementContext.class,0);
		}
		public ExpressionContext expression() {
			return getRuleContext(ExpressionContext.class,0);
		}
		public BlockContext block() {
			return getRuleContext(BlockContext.class,0);
		}
		public StatementContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_statement; }
	}

	public final StatementContext statement() throws RecognitionException {
		StatementContext _localctx = new StatementContext(_ctx, getState());
		enterRule(_localctx, 2, RULE_statement);
		try {
			setState(76);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,5,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				setState(58);
				declaration();
				setState(60);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,1,_ctx) ) {
				case 1:
					{
					setState(59);
					match(SEMI);
					}
					break;
				}
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(62);
				assignment();
				setState(64);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,2,_ctx) ) {
				case 1:
					{
					setState(63);
					match(SEMI);
					}
					break;
				}
				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(66);
				returnStatement();
				setState(68);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,3,_ctx) ) {
				case 1:
					{
					setState(67);
					match(SEMI);
					}
					break;
				}
				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(70);
				expression();
				setState(72);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,4,_ctx) ) {
				case 1:
					{
					setState(71);
					match(SEMI);
					}
					break;
				}
				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{
				setState(74);
				block();
				}
				break;
			case 6:
				enterOuterAlt(_localctx, 6);
				{
				setState(75);
				match(SEMI);
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class DeclarationContext extends ParserRuleContext {
		public TerminalNode IDENTIFIER() { return getToken(SardParser.IDENTIFIER, 0); }
		public TerminalNode COLON() { return getToken(SardParser.COLON, 0); }
		public TypeContext type() {
			return getRuleContext(TypeContext.class,0);
		}
		public TerminalNode EQ() { return getToken(SardParser.EQ, 0); }
		public ExpressionContext expression() {
			return getRuleContext(ExpressionContext.class,0);
		}
		public ParameterListContext parameterList() {
			return getRuleContext(ParameterListContext.class,0);
		}
		public BlockContext block() {
			return getRuleContext(BlockContext.class,0);
		}
		public DeclarationContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_declaration; }
	}

	public final DeclarationContext declaration() throws RecognitionException {
		DeclarationContext _localctx = new DeclarationContext(_ctx, getState());
		enterRule(_localctx, 4, RULE_declaration);
		try {
			setState(98);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,9,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				setState(78);
				match(IDENTIFIER);
				setState(79);
				match(COLON);
				setState(80);
				type();
				setState(81);
				match(EQ);
				setState(82);
				expression();
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(84);
				match(IDENTIFIER);
				setState(85);
				match(COLON);
				setState(87);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,6,_ctx) ) {
				case 1:
					{
					setState(86);
					type();
					}
					break;
				}
				setState(90);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,7,_ctx) ) {
				case 1:
					{
					setState(89);
					parameterList();
					}
					break;
				}
				setState(93);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,8,_ctx) ) {
				case 1:
					{
					setState(92);
					block();
					}
					break;
				}
				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(95);
				match(IDENTIFIER);
				setState(96);
				match(COLON);
				setState(97);
				type();
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class TypeContext extends ParserRuleContext {
		public List<TerminalNode> IDENTIFIER() { return getTokens(SardParser.IDENTIFIER); }
		public TerminalNode IDENTIFIER(int i) {
			return getToken(SardParser.IDENTIFIER, i);
		}
		public List<TerminalNode> DOT() { return getTokens(SardParser.DOT); }
		public TerminalNode DOT(int i) {
			return getToken(SardParser.DOT, i);
		}
		public TypeContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_type; }
	}

	public final TypeContext type() throws RecognitionException {
		TypeContext _localctx = new TypeContext(_ctx, getState());
		enterRule(_localctx, 6, RULE_type);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(100);
			match(IDENTIFIER);
			setState(105);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==DOT) {
				{
				{
				setState(101);
				match(DOT);
				setState(102);
				match(IDENTIFIER);
				}
				}
				setState(107);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ParameterListContext extends ParserRuleContext {
		public TerminalNode LPAREN() { return getToken(SardParser.LPAREN, 0); }
		public TerminalNode RPAREN() { return getToken(SardParser.RPAREN, 0); }
		public List<TerminalNode> IDENTIFIER() { return getTokens(SardParser.IDENTIFIER); }
		public TerminalNode IDENTIFIER(int i) {
			return getToken(SardParser.IDENTIFIER, i);
		}
		public List<TerminalNode> COMMA() { return getTokens(SardParser.COMMA); }
		public TerminalNode COMMA(int i) {
			return getToken(SardParser.COMMA, i);
		}
		public ParameterListContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_parameterList; }
	}

	public final ParameterListContext parameterList() throws RecognitionException {
		ParameterListContext _localctx = new ParameterListContext(_ctx, getState());
		enterRule(_localctx, 8, RULE_parameterList);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(108);
			match(LPAREN);
			setState(117);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==IDENTIFIER) {
				{
				setState(109);
				match(IDENTIFIER);
				setState(114);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==COMMA) {
					{
					{
					setState(110);
					match(COMMA);
					setState(111);
					match(IDENTIFIER);
					}
					}
					setState(116);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				}
			}

			setState(119);
			match(RPAREN);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class AssignmentContext extends ParserRuleContext {
		public LvalueContext lvalue() {
			return getRuleContext(LvalueContext.class,0);
		}
		public TerminalNode EQ() { return getToken(SardParser.EQ, 0); }
		public ExpressionContext expression() {
			return getRuleContext(ExpressionContext.class,0);
		}
		public TerminalNode PLUS_ASSIGN() { return getToken(SardParser.PLUS_ASSIGN, 0); }
		public TerminalNode MINUS_ASSIGN() { return getToken(SardParser.MINUS_ASSIGN, 0); }
		public AssignmentContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_assignment; }
	}

	public final AssignmentContext assignment() throws RecognitionException {
		AssignmentContext _localctx = new AssignmentContext(_ctx, getState());
		enterRule(_localctx, 10, RULE_assignment);
		try {
			setState(133);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,13,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				setState(121);
				lvalue();
				setState(122);
				match(EQ);
				setState(123);
				expression();
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(125);
				lvalue();
				setState(126);
				match(PLUS_ASSIGN);
				setState(127);
				expression();
				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(129);
				lvalue();
				setState(130);
				match(MINUS_ASSIGN);
				setState(131);
				expression();
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class LvalueContext extends ParserRuleContext {
		public List<TerminalNode> IDENTIFIER() { return getTokens(SardParser.IDENTIFIER); }
		public TerminalNode IDENTIFIER(int i) {
			return getToken(SardParser.IDENTIFIER, i);
		}
		public List<TerminalNode> DOT() { return getTokens(SardParser.DOT); }
		public TerminalNode DOT(int i) {
			return getToken(SardParser.DOT, i);
		}
		public List<TerminalNode> LBRACKET() { return getTokens(SardParser.LBRACKET); }
		public TerminalNode LBRACKET(int i) {
			return getToken(SardParser.LBRACKET, i);
		}
		public List<ExpressionContext> expression() {
			return getRuleContexts(ExpressionContext.class);
		}
		public ExpressionContext expression(int i) {
			return getRuleContext(ExpressionContext.class,i);
		}
		public List<TerminalNode> RBRACKET() { return getTokens(SardParser.RBRACKET); }
		public TerminalNode RBRACKET(int i) {
			return getToken(SardParser.RBRACKET, i);
		}
		public LvalueContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_lvalue; }
	}

	public final LvalueContext lvalue() throws RecognitionException {
		LvalueContext _localctx = new LvalueContext(_ctx, getState());
		enterRule(_localctx, 12, RULE_lvalue);
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(135);
			match(IDENTIFIER);
			setState(144);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,15,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					{
					setState(142);
					_errHandler.sync(this);
					switch (_input.LA(1)) {
					case DOT:
						{
						setState(136);
						match(DOT);
						setState(137);
						match(IDENTIFIER);
						}
						break;
					case LBRACKET:
						{
						setState(138);
						match(LBRACKET);
						setState(139);
						expression();
						setState(140);
						match(RBRACKET);
						}
						break;
					default:
						throw new NoViableAltException(this);
					}
					} 
				}
				setState(146);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,15,_ctx);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ReturnStatementContext extends ParserRuleContext {
		public TerminalNode EQ() { return getToken(SardParser.EQ, 0); }
		public ExpressionContext expression() {
			return getRuleContext(ExpressionContext.class,0);
		}
		public ReturnStatementContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_returnStatement; }
	}

	public final ReturnStatementContext returnStatement() throws RecognitionException {
		ReturnStatementContext _localctx = new ReturnStatementContext(_ctx, getState());
		enterRule(_localctx, 14, RULE_returnStatement);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(147);
			match(EQ);
			setState(148);
			expression();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class BlockContext extends ParserRuleContext {
		public TerminalNode LBRACE() { return getToken(SardParser.LBRACE, 0); }
		public TerminalNode RBRACE() { return getToken(SardParser.RBRACE, 0); }
		public List<StatementContext> statement() {
			return getRuleContexts(StatementContext.class);
		}
		public StatementContext statement(int i) {
			return getRuleContext(StatementContext.class,i);
		}
		public BlockContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_block; }
	}

	public final BlockContext block() throws RecognitionException {
		BlockContext _localctx = new BlockContext(_ctx, getState());
		enterRule(_localctx, 16, RULE_block);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(150);
			match(LBRACE);
			setState(154);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << NOT) | (1L << TRUE) | (1L << FALSE) | (1L << TILDETILDE) | (1L << INC) | (1L << DEC) | (1L << PLUS) | (1L << MINUS) | (1L << BANG) | (1L << TILDE) | (1L << AT) | (1L << EQ) | (1L << LPAREN) | (1L << LBRACE) | (1L << LBRACKET) | (1L << SEMI) | (1L << CURRENCY_LITERAL) | (1L << COLOR_LITERAL) | (1L << HEX_LITERAL) | (1L << NUMBER_LITERAL) | (1L << INTEGER_LITERAL) | (1L << ESCAPE_SEQ) | (1L << STRING_LITERAL) | (1L << IDENTIFIER))) != 0)) {
				{
				{
				setState(151);
				statement();
				}
				}
				setState(156);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(157);
			match(RBRACE);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ExpressionContext extends ParserRuleContext {
		public LogicalOrExprContext logicalOrExpr() {
			return getRuleContext(LogicalOrExprContext.class,0);
		}
		public ExpressionContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_expression; }
	}

	public final ExpressionContext expression() throws RecognitionException {
		ExpressionContext _localctx = new ExpressionContext(_ctx, getState());
		enterRule(_localctx, 18, RULE_expression);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(159);
			logicalOrExpr();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class LogicalOrExprContext extends ParserRuleContext {
		public List<LogicalAndExprContext> logicalAndExpr() {
			return getRuleContexts(LogicalAndExprContext.class);
		}
		public LogicalAndExprContext logicalAndExpr(int i) {
			return getRuleContext(LogicalAndExprContext.class,i);
		}
		public List<TerminalNode> BAR() { return getTokens(SardParser.BAR); }
		public TerminalNode BAR(int i) {
			return getToken(SardParser.BAR, i);
		}
		public List<TerminalNode> OR() { return getTokens(SardParser.OR); }
		public TerminalNode OR(int i) {
			return getToken(SardParser.OR, i);
		}
		public LogicalOrExprContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_logicalOrExpr; }
	}

	public final LogicalOrExprContext logicalOrExpr() throws RecognitionException {
		LogicalOrExprContext _localctx = new LogicalOrExprContext(_ctx, getState());
		enterRule(_localctx, 20, RULE_logicalOrExpr);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(161);
			logicalAndExpr();
			setState(166);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,17,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					{
					{
					setState(162);
					_la = _input.LA(1);
					if ( !(_la==OR || _la==BAR) ) {
					_errHandler.recoverInline(this);
					}
					else {
						if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
						_errHandler.reportMatch(this);
						consume();
					}
					setState(163);
					logicalAndExpr();
					}
					} 
				}
				setState(168);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,17,_ctx);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class LogicalAndExprContext extends ParserRuleContext {
		public List<ComparisonExprContext> comparisonExpr() {
			return getRuleContexts(ComparisonExprContext.class);
		}
		public ComparisonExprContext comparisonExpr(int i) {
			return getRuleContext(ComparisonExprContext.class,i);
		}
		public List<TerminalNode> AMPERSAND() { return getTokens(SardParser.AMPERSAND); }
		public TerminalNode AMPERSAND(int i) {
			return getToken(SardParser.AMPERSAND, i);
		}
		public List<TerminalNode> AND() { return getTokens(SardParser.AND); }
		public TerminalNode AND(int i) {
			return getToken(SardParser.AND, i);
		}
		public LogicalAndExprContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_logicalAndExpr; }
	}

	public final LogicalAndExprContext logicalAndExpr() throws RecognitionException {
		LogicalAndExprContext _localctx = new LogicalAndExprContext(_ctx, getState());
		enterRule(_localctx, 22, RULE_logicalAndExpr);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(169);
			comparisonExpr();
			setState(174);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,18,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					{
					{
					setState(170);
					_la = _input.LA(1);
					if ( !(_la==AND || _la==AMPERSAND) ) {
					_errHandler.recoverInline(this);
					}
					else {
						if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
						_errHandler.reportMatch(this);
						consume();
					}
					setState(171);
					comparisonExpr();
					}
					} 
				}
				setState(176);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,18,_ctx);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ComparisonExprContext extends ParserRuleContext {
		public List<TypeCheckExprContext> typeCheckExpr() {
			return getRuleContexts(TypeCheckExprContext.class);
		}
		public TypeCheckExprContext typeCheckExpr(int i) {
			return getRuleContext(TypeCheckExprContext.class,i);
		}
		public List<TerminalNode> EQ() { return getTokens(SardParser.EQ); }
		public TerminalNode EQ(int i) {
			return getToken(SardParser.EQ, i);
		}
		public List<TerminalNode> NEQ() { return getTokens(SardParser.NEQ); }
		public TerminalNode NEQ(int i) {
			return getToken(SardParser.NEQ, i);
		}
		public List<TerminalNode> NNEQ() { return getTokens(SardParser.NNEQ); }
		public TerminalNode NNEQ(int i) {
			return getToken(SardParser.NNEQ, i);
		}
		public List<TerminalNode> LT() { return getTokens(SardParser.LT); }
		public TerminalNode LT(int i) {
			return getToken(SardParser.LT, i);
		}
		public List<TerminalNode> GT() { return getTokens(SardParser.GT); }
		public TerminalNode GT(int i) {
			return getToken(SardParser.GT, i);
		}
		public List<TerminalNode> LTE() { return getTokens(SardParser.LTE); }
		public TerminalNode LTE(int i) {
			return getToken(SardParser.LTE, i);
		}
		public List<TerminalNode> GTE() { return getTokens(SardParser.GTE); }
		public TerminalNode GTE(int i) {
			return getToken(SardParser.GTE, i);
		}
		public ComparisonExprContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_comparisonExpr; }
	}

	public final ComparisonExprContext comparisonExpr() throws RecognitionException {
		ComparisonExprContext _localctx = new ComparisonExprContext(_ctx, getState());
		enterRule(_localctx, 24, RULE_comparisonExpr);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(177);
			typeCheckExpr();
			setState(182);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,19,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					{
					{
					setState(178);
					_la = _input.LA(1);
					if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << NEQ) | (1L << NNEQ) | (1L << LTE) | (1L << GTE) | (1L << EQ) | (1L << LT) | (1L << GT))) != 0)) ) {
					_errHandler.recoverInline(this);
					}
					else {
						if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
						_errHandler.reportMatch(this);
						consume();
					}
					setState(179);
					typeCheckExpr();
					}
					} 
				}
				setState(184);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,19,_ctx);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class TypeCheckExprContext extends ParserRuleContext {
		public List<AdditiveExprContext> additiveExpr() {
			return getRuleContexts(AdditiveExprContext.class);
		}
		public AdditiveExprContext additiveExpr(int i) {
			return getRuleContext(AdditiveExprContext.class,i);
		}
		public TerminalNode TYPEEQ() { return getToken(SardParser.TYPEEQ, 0); }
		public TypeCheckExprContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_typeCheckExpr; }
	}

	public final TypeCheckExprContext typeCheckExpr() throws RecognitionException {
		TypeCheckExprContext _localctx = new TypeCheckExprContext(_ctx, getState());
		enterRule(_localctx, 26, RULE_typeCheckExpr);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(185);
			additiveExpr();
			setState(188);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,20,_ctx) ) {
			case 1:
				{
				setState(186);
				match(TYPEEQ);
				setState(187);
				additiveExpr();
				}
				break;
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class AdditiveExprContext extends ParserRuleContext {
		public List<MultiplicativeExprContext> multiplicativeExpr() {
			return getRuleContexts(MultiplicativeExprContext.class);
		}
		public MultiplicativeExprContext multiplicativeExpr(int i) {
			return getRuleContext(MultiplicativeExprContext.class,i);
		}
		public List<TerminalNode> PLUS() { return getTokens(SardParser.PLUS); }
		public TerminalNode PLUS(int i) {
			return getToken(SardParser.PLUS, i);
		}
		public List<TerminalNode> MINUS() { return getTokens(SardParser.MINUS); }
		public TerminalNode MINUS(int i) {
			return getToken(SardParser.MINUS, i);
		}
		public AdditiveExprContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_additiveExpr; }
	}

	public final AdditiveExprContext additiveExpr() throws RecognitionException {
		AdditiveExprContext _localctx = new AdditiveExprContext(_ctx, getState());
		enterRule(_localctx, 28, RULE_additiveExpr);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(190);
			multiplicativeExpr();
			setState(195);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,21,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					{
					{
					setState(191);
					_la = _input.LA(1);
					if ( !(_la==PLUS || _la==MINUS) ) {
					_errHandler.recoverInline(this);
					}
					else {
						if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
						_errHandler.reportMatch(this);
						consume();
					}
					setState(192);
					multiplicativeExpr();
					}
					} 
				}
				setState(197);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,21,_ctx);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class MultiplicativeExprContext extends ParserRuleContext {
		public List<PowerExprContext> powerExpr() {
			return getRuleContexts(PowerExprContext.class);
		}
		public PowerExprContext powerExpr(int i) {
			return getRuleContext(PowerExprContext.class,i);
		}
		public List<TerminalNode> STAR() { return getTokens(SardParser.STAR); }
		public TerminalNode STAR(int i) {
			return getToken(SardParser.STAR, i);
		}
		public List<TerminalNode> SLASH() { return getTokens(SardParser.SLASH); }
		public TerminalNode SLASH(int i) {
			return getToken(SardParser.SLASH, i);
		}
		public List<TerminalNode> MOD() { return getTokens(SardParser.MOD); }
		public TerminalNode MOD(int i) {
			return getToken(SardParser.MOD, i);
		}
		public MultiplicativeExprContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_multiplicativeExpr; }
	}

	public final MultiplicativeExprContext multiplicativeExpr() throws RecognitionException {
		MultiplicativeExprContext _localctx = new MultiplicativeExprContext(_ctx, getState());
		enterRule(_localctx, 30, RULE_multiplicativeExpr);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(198);
			powerExpr();
			setState(203);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,22,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					{
					{
					setState(199);
					_la = _input.LA(1);
					if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << MOD) | (1L << STAR) | (1L << SLASH))) != 0)) ) {
					_errHandler.recoverInline(this);
					}
					else {
						if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
						_errHandler.reportMatch(this);
						consume();
					}
					setState(200);
					powerExpr();
					}
					} 
				}
				setState(205);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,22,_ctx);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class PowerExprContext extends ParserRuleContext {
		public UnaryExprContext unaryExpr() {
			return getRuleContext(UnaryExprContext.class,0);
		}
		public TerminalNode CARET() { return getToken(SardParser.CARET, 0); }
		public PowerExprContext powerExpr() {
			return getRuleContext(PowerExprContext.class,0);
		}
		public PowerExprContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_powerExpr; }
	}

	public final PowerExprContext powerExpr() throws RecognitionException {
		PowerExprContext _localctx = new PowerExprContext(_ctx, getState());
		enterRule(_localctx, 32, RULE_powerExpr);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(206);
			unaryExpr();
			setState(209);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,23,_ctx) ) {
			case 1:
				{
				setState(207);
				match(CARET);
				setState(208);
				powerExpr();
				}
				break;
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class UnaryExprContext extends ParserRuleContext {
		public TerminalNode MINUS() { return getToken(SardParser.MINUS, 0); }
		public UnaryExprContext unaryExpr() {
			return getRuleContext(UnaryExprContext.class,0);
		}
		public TerminalNode PLUS() { return getToken(SardParser.PLUS, 0); }
		public TerminalNode BANG() { return getToken(SardParser.BANG, 0); }
		public TerminalNode NOT() { return getToken(SardParser.NOT, 0); }
		public TerminalNode INC() { return getToken(SardParser.INC, 0); }
		public LvalueContext lvalue() {
			return getRuleContext(LvalueContext.class,0);
		}
		public TerminalNode DEC() { return getToken(SardParser.DEC, 0); }
		public PostfixExprContext postfixExpr() {
			return getRuleContext(PostfixExprContext.class,0);
		}
		public UnaryExprContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_unaryExpr; }
	}

	public final UnaryExprContext unaryExpr() throws RecognitionException {
		UnaryExprContext _localctx = new UnaryExprContext(_ctx, getState());
		enterRule(_localctx, 34, RULE_unaryExpr);
		try {
			setState(224);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case MINUS:
				enterOuterAlt(_localctx, 1);
				{
				setState(211);
				match(MINUS);
				setState(212);
				unaryExpr();
				}
				break;
			case PLUS:
				enterOuterAlt(_localctx, 2);
				{
				setState(213);
				match(PLUS);
				setState(214);
				unaryExpr();
				}
				break;
			case BANG:
				enterOuterAlt(_localctx, 3);
				{
				setState(215);
				match(BANG);
				setState(216);
				unaryExpr();
				}
				break;
			case NOT:
				enterOuterAlt(_localctx, 4);
				{
				setState(217);
				match(NOT);
				setState(218);
				unaryExpr();
				}
				break;
			case INC:
				enterOuterAlt(_localctx, 5);
				{
				setState(219);
				match(INC);
				setState(220);
				lvalue();
				}
				break;
			case DEC:
				enterOuterAlt(_localctx, 6);
				{
				setState(221);
				match(DEC);
				setState(222);
				lvalue();
				}
				break;
			case TRUE:
			case FALSE:
			case TILDETILDE:
			case TILDE:
			case AT:
			case LPAREN:
			case LBRACE:
			case LBRACKET:
			case CURRENCY_LITERAL:
			case COLOR_LITERAL:
			case HEX_LITERAL:
			case NUMBER_LITERAL:
			case INTEGER_LITERAL:
			case ESCAPE_SEQ:
			case STRING_LITERAL:
			case IDENTIFIER:
				enterOuterAlt(_localctx, 7);
				{
				setState(223);
				postfixExpr();
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class PostfixExprContext extends ParserRuleContext {
		public PrimaryExprContext primaryExpr() {
			return getRuleContext(PrimaryExprContext.class,0);
		}
		public List<PostfixLinkContext> postfixLink() {
			return getRuleContexts(PostfixLinkContext.class);
		}
		public PostfixLinkContext postfixLink(int i) {
			return getRuleContext(PostfixLinkContext.class,i);
		}
		public PostfixExprContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_postfixExpr; }
	}

	public final PostfixExprContext postfixExpr() throws RecognitionException {
		PostfixExprContext _localctx = new PostfixExprContext(_ctx, getState());
		enterRule(_localctx, 36, RULE_postfixExpr);
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(226);
			primaryExpr();
			setState(230);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,25,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					{
					{
					setState(227);
					postfixLink();
					}
					} 
				}
				setState(232);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,25,_ctx);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class PostfixLinkContext extends ParserRuleContext {
		public TerminalNode DOT() { return getToken(SardParser.DOT, 0); }
		public TerminalNode IDENTIFIER() { return getToken(SardParser.IDENTIFIER, 0); }
		public TerminalNode LBRACKET() { return getToken(SardParser.LBRACKET, 0); }
		public ExpressionContext expression() {
			return getRuleContext(ExpressionContext.class,0);
		}
		public TerminalNode RBRACKET() { return getToken(SardParser.RBRACKET, 0); }
		public ArgumentListContext argumentList() {
			return getRuleContext(ArgumentListContext.class,0);
		}
		public BlockContext block() {
			return getRuleContext(BlockContext.class,0);
		}
		public NamedBlockContext namedBlock() {
			return getRuleContext(NamedBlockContext.class,0);
		}
		public TerminalNode PERCENT() { return getToken(SardParser.PERCENT, 0); }
		public TerminalNode INC() { return getToken(SardParser.INC, 0); }
		public TerminalNode DEC() { return getToken(SardParser.DEC, 0); }
		public PostfixLinkContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_postfixLink; }
	}

	public final PostfixLinkContext postfixLink() throws RecognitionException {
		PostfixLinkContext _localctx = new PostfixLinkContext(_ctx, getState());
		enterRule(_localctx, 38, RULE_postfixLink);
		try {
			setState(248);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case DOT:
				enterOuterAlt(_localctx, 1);
				{
				setState(233);
				match(DOT);
				setState(234);
				match(IDENTIFIER);
				}
				break;
			case LBRACKET:
				enterOuterAlt(_localctx, 2);
				{
				setState(235);
				match(LBRACKET);
				setState(236);
				expression();
				setState(237);
				match(RBRACKET);
				}
				break;
			case LPAREN:
				enterOuterAlt(_localctx, 3);
				{
				setState(239);
				argumentList();
				setState(241);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,26,_ctx) ) {
				case 1:
					{
					setState(240);
					block();
					}
					break;
				}
				}
				break;
			case IDENTIFIER:
				enterOuterAlt(_localctx, 4);
				{
				setState(243);
				namedBlock();
				}
				break;
			case LBRACE:
				enterOuterAlt(_localctx, 5);
				{
				setState(244);
				block();
				}
				break;
			case PERCENT:
				enterOuterAlt(_localctx, 6);
				{
				setState(245);
				match(PERCENT);
				}
				break;
			case INC:
				enterOuterAlt(_localctx, 7);
				{
				setState(246);
				match(INC);
				}
				break;
			case DEC:
				enterOuterAlt(_localctx, 8);
				{
				setState(247);
				match(DEC);
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ArgumentListContext extends ParserRuleContext {
		public TerminalNode LPAREN() { return getToken(SardParser.LPAREN, 0); }
		public TerminalNode RPAREN() { return getToken(SardParser.RPAREN, 0); }
		public List<ExpressionContext> expression() {
			return getRuleContexts(ExpressionContext.class);
		}
		public ExpressionContext expression(int i) {
			return getRuleContext(ExpressionContext.class,i);
		}
		public List<TerminalNode> COMMA() { return getTokens(SardParser.COMMA); }
		public TerminalNode COMMA(int i) {
			return getToken(SardParser.COMMA, i);
		}
		public ArgumentListContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_argumentList; }
	}

	public final ArgumentListContext argumentList() throws RecognitionException {
		ArgumentListContext _localctx = new ArgumentListContext(_ctx, getState());
		enterRule(_localctx, 40, RULE_argumentList);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(250);
			match(LPAREN);
			setState(259);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << NOT) | (1L << TRUE) | (1L << FALSE) | (1L << TILDETILDE) | (1L << INC) | (1L << DEC) | (1L << PLUS) | (1L << MINUS) | (1L << BANG) | (1L << TILDE) | (1L << AT) | (1L << LPAREN) | (1L << LBRACE) | (1L << LBRACKET) | (1L << CURRENCY_LITERAL) | (1L << COLOR_LITERAL) | (1L << HEX_LITERAL) | (1L << NUMBER_LITERAL) | (1L << INTEGER_LITERAL) | (1L << ESCAPE_SEQ) | (1L << STRING_LITERAL) | (1L << IDENTIFIER))) != 0)) {
				{
				setState(251);
				expression();
				setState(256);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==COMMA) {
					{
					{
					setState(252);
					match(COMMA);
					setState(253);
					expression();
					}
					}
					setState(258);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				}
			}

			setState(261);
			match(RPAREN);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class NamedBlockContext extends ParserRuleContext {
		public TerminalNode IDENTIFIER() { return getToken(SardParser.IDENTIFIER, 0); }
		public BlockContext block() {
			return getRuleContext(BlockContext.class,0);
		}
		public ArgumentListContext argumentList() {
			return getRuleContext(ArgumentListContext.class,0);
		}
		public NamedBlockContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_namedBlock; }
	}

	public final NamedBlockContext namedBlock() throws RecognitionException {
		NamedBlockContext _localctx = new NamedBlockContext(_ctx, getState());
		enterRule(_localctx, 42, RULE_namedBlock);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(263);
			match(IDENTIFIER);
			setState(265);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==LPAREN) {
				{
				setState(264);
				argumentList();
				}
			}

			setState(267);
			block();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class PrimaryExprContext extends ParserRuleContext {
		public LiteralContext literal() {
			return getRuleContext(LiteralContext.class,0);
		}
		public TerminalNode TRUE() { return getToken(SardParser.TRUE, 0); }
		public TerminalNode FALSE() { return getToken(SardParser.FALSE, 0); }
		public TerminalNode IDENTIFIER() { return getToken(SardParser.IDENTIFIER, 0); }
		public TerminalNode LPAREN() { return getToken(SardParser.LPAREN, 0); }
		public ExpressionContext expression() {
			return getRuleContext(ExpressionContext.class,0);
		}
		public TerminalNode RPAREN() { return getToken(SardParser.RPAREN, 0); }
		public BlockContext block() {
			return getRuleContext(BlockContext.class,0);
		}
		public TerminalNode TILDE() { return getToken(SardParser.TILDE, 0); }
		public TerminalNode TILDETILDE() { return getToken(SardParser.TILDETILDE, 0); }
		public TerminalNode AT() { return getToken(SardParser.AT, 0); }
		public ArrayLiteralContext arrayLiteral() {
			return getRuleContext(ArrayLiteralContext.class,0);
		}
		public PrimaryExprContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_primaryExpr; }
	}

	public final PrimaryExprContext primaryExpr() throws RecognitionException {
		PrimaryExprContext _localctx = new PrimaryExprContext(_ctx, getState());
		enterRule(_localctx, 44, RULE_primaryExpr);
		try {
			setState(285);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case CURRENCY_LITERAL:
			case COLOR_LITERAL:
			case HEX_LITERAL:
			case NUMBER_LITERAL:
			case INTEGER_LITERAL:
			case ESCAPE_SEQ:
			case STRING_LITERAL:
				enterOuterAlt(_localctx, 1);
				{
				setState(269);
				literal();
				}
				break;
			case TRUE:
				enterOuterAlt(_localctx, 2);
				{
				setState(270);
				match(TRUE);
				}
				break;
			case FALSE:
				enterOuterAlt(_localctx, 3);
				{
				setState(271);
				match(FALSE);
				}
				break;
			case IDENTIFIER:
				enterOuterAlt(_localctx, 4);
				{
				setState(272);
				match(IDENTIFIER);
				}
				break;
			case LPAREN:
				enterOuterAlt(_localctx, 5);
				{
				setState(273);
				match(LPAREN);
				setState(274);
				expression();
				setState(275);
				match(RPAREN);
				}
				break;
			case LBRACE:
				enterOuterAlt(_localctx, 6);
				{
				setState(277);
				block();
				}
				break;
			case TILDE:
				enterOuterAlt(_localctx, 7);
				{
				setState(278);
				match(TILDE);
				setState(279);
				match(IDENTIFIER);
				}
				break;
			case TILDETILDE:
				enterOuterAlt(_localctx, 8);
				{
				setState(280);
				match(TILDETILDE);
				setState(281);
				match(IDENTIFIER);
				}
				break;
			case AT:
				enterOuterAlt(_localctx, 9);
				{
				setState(282);
				match(AT);
				setState(283);
				expression();
				}
				break;
			case LBRACKET:
				enterOuterAlt(_localctx, 10);
				{
				setState(284);
				arrayLiteral();
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class LiteralContext extends ParserRuleContext {
		public TerminalNode INTEGER_LITERAL() { return getToken(SardParser.INTEGER_LITERAL, 0); }
		public TerminalNode NUMBER_LITERAL() { return getToken(SardParser.NUMBER_LITERAL, 0); }
		public TerminalNode HEX_LITERAL() { return getToken(SardParser.HEX_LITERAL, 0); }
		public TerminalNode STRING_LITERAL() { return getToken(SardParser.STRING_LITERAL, 0); }
		public TerminalNode COLOR_LITERAL() { return getToken(SardParser.COLOR_LITERAL, 0); }
		public TerminalNode CURRENCY_LITERAL() { return getToken(SardParser.CURRENCY_LITERAL, 0); }
		public TerminalNode ESCAPE_SEQ() { return getToken(SardParser.ESCAPE_SEQ, 0); }
		public LiteralContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_literal; }
	}

	public final LiteralContext literal() throws RecognitionException {
		LiteralContext _localctx = new LiteralContext(_ctx, getState());
		enterRule(_localctx, 46, RULE_literal);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(287);
			_la = _input.LA(1);
			if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << CURRENCY_LITERAL) | (1L << COLOR_LITERAL) | (1L << HEX_LITERAL) | (1L << NUMBER_LITERAL) | (1L << INTEGER_LITERAL) | (1L << ESCAPE_SEQ) | (1L << STRING_LITERAL))) != 0)) ) {
			_errHandler.recoverInline(this);
			}
			else {
				if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
				_errHandler.reportMatch(this);
				consume();
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ArrayLiteralContext extends ParserRuleContext {
		public TerminalNode LBRACKET() { return getToken(SardParser.LBRACKET, 0); }
		public TerminalNode RBRACKET() { return getToken(SardParser.RBRACKET, 0); }
		public List<ExpressionContext> expression() {
			return getRuleContexts(ExpressionContext.class);
		}
		public ExpressionContext expression(int i) {
			return getRuleContext(ExpressionContext.class,i);
		}
		public List<TerminalNode> COMMA() { return getTokens(SardParser.COMMA); }
		public TerminalNode COMMA(int i) {
			return getToken(SardParser.COMMA, i);
		}
		public ArrayLiteralContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_arrayLiteral; }
	}

	public final ArrayLiteralContext arrayLiteral() throws RecognitionException {
		ArrayLiteralContext _localctx = new ArrayLiteralContext(_ctx, getState());
		enterRule(_localctx, 48, RULE_arrayLiteral);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(289);
			match(LBRACKET);
			setState(298);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << NOT) | (1L << TRUE) | (1L << FALSE) | (1L << TILDETILDE) | (1L << INC) | (1L << DEC) | (1L << PLUS) | (1L << MINUS) | (1L << BANG) | (1L << TILDE) | (1L << AT) | (1L << LPAREN) | (1L << LBRACE) | (1L << LBRACKET) | (1L << CURRENCY_LITERAL) | (1L << COLOR_LITERAL) | (1L << HEX_LITERAL) | (1L << NUMBER_LITERAL) | (1L << INTEGER_LITERAL) | (1L << ESCAPE_SEQ) | (1L << STRING_LITERAL) | (1L << IDENTIFIER))) != 0)) {
				{
				setState(290);
				expression();
				setState(295);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==COMMA) {
					{
					{
					setState(291);
					match(COMMA);
					setState(292);
					expression();
					}
					}
					setState(297);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				}
			}

			setState(300);
			match(RBRACKET);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static final String _serializedATN =
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\3\66\u0131\4\2\t\2"+
		"\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4\13"+
		"\t\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21\4\22\t\22"+
		"\4\23\t\23\4\24\t\24\4\25\t\25\4\26\t\26\4\27\t\27\4\30\t\30\4\31\t\31"+
		"\4\32\t\32\3\2\7\2\66\n\2\f\2\16\29\13\2\3\2\3\2\3\3\3\3\5\3?\n\3\3\3"+
		"\3\3\5\3C\n\3\3\3\3\3\5\3G\n\3\3\3\3\3\5\3K\n\3\3\3\3\3\5\3O\n\3\3\4\3"+
		"\4\3\4\3\4\3\4\3\4\3\4\3\4\3\4\5\4Z\n\4\3\4\5\4]\n\4\3\4\5\4`\n\4\3\4"+
		"\3\4\3\4\5\4e\n\4\3\5\3\5\3\5\7\5j\n\5\f\5\16\5m\13\5\3\6\3\6\3\6\3\6"+
		"\7\6s\n\6\f\6\16\6v\13\6\5\6x\n\6\3\6\3\6\3\7\3\7\3\7\3\7\3\7\3\7\3\7"+
		"\3\7\3\7\3\7\3\7\3\7\5\7\u0088\n\7\3\b\3\b\3\b\3\b\3\b\3\b\3\b\7\b\u0091"+
		"\n\b\f\b\16\b\u0094\13\b\3\t\3\t\3\t\3\n\3\n\7\n\u009b\n\n\f\n\16\n\u009e"+
		"\13\n\3\n\3\n\3\13\3\13\3\f\3\f\3\f\7\f\u00a7\n\f\f\f\16\f\u00aa\13\f"+
		"\3\r\3\r\3\r\7\r\u00af\n\r\f\r\16\r\u00b2\13\r\3\16\3\16\3\16\7\16\u00b7"+
		"\n\16\f\16\16\16\u00ba\13\16\3\17\3\17\3\17\5\17\u00bf\n\17\3\20\3\20"+
		"\3\20\7\20\u00c4\n\20\f\20\16\20\u00c7\13\20\3\21\3\21\3\21\7\21\u00cc"+
		"\n\21\f\21\16\21\u00cf\13\21\3\22\3\22\3\22\5\22\u00d4\n\22\3\23\3\23"+
		"\3\23\3\23\3\23\3\23\3\23\3\23\3\23\3\23\3\23\3\23\3\23\5\23\u00e3\n\23"+
		"\3\24\3\24\7\24\u00e7\n\24\f\24\16\24\u00ea\13\24\3\25\3\25\3\25\3\25"+
		"\3\25\3\25\3\25\3\25\5\25\u00f4\n\25\3\25\3\25\3\25\3\25\3\25\5\25\u00fb"+
		"\n\25\3\26\3\26\3\26\3\26\7\26\u0101\n\26\f\26\16\26\u0104\13\26\5\26"+
		"\u0106\n\26\3\26\3\26\3\27\3\27\5\27\u010c\n\27\3\27\3\27\3\30\3\30\3"+
		"\30\3\30\3\30\3\30\3\30\3\30\3\30\3\30\3\30\3\30\3\30\3\30\3\30\3\30\5"+
		"\30\u0120\n\30\3\31\3\31\3\32\3\32\3\32\3\32\7\32\u0128\n\32\f\32\16\32"+
		"\u012b\13\32\5\32\u012d\n\32\3\32\3\32\3\32\2\2\33\2\4\6\b\n\f\16\20\22"+
		"\24\26\30\32\34\36 \"$&(*,.\60\62\2\b\4\2\4\4\33\33\4\2\3\3\32\32\4\2"+
		"\13\16\37!\3\2\24\25\4\2\6\6\26\27\3\2,\62\2\u0152\2\67\3\2\2\2\4N\3\2"+
		"\2\2\6d\3\2\2\2\bf\3\2\2\2\nn\3\2\2\2\f\u0087\3\2\2\2\16\u0089\3\2\2\2"+
		"\20\u0095\3\2\2\2\22\u0098\3\2\2\2\24\u00a1\3\2\2\2\26\u00a3\3\2\2\2\30"+
		"\u00ab\3\2\2\2\32\u00b3\3\2\2\2\34\u00bb\3\2\2\2\36\u00c0\3\2\2\2 \u00c8"+
		"\3\2\2\2\"\u00d0\3\2\2\2$\u00e2\3\2\2\2&\u00e4\3\2\2\2(\u00fa\3\2\2\2"+
		"*\u00fc\3\2\2\2,\u0109\3\2\2\2.\u011f\3\2\2\2\60\u0121\3\2\2\2\62\u0123"+
		"\3\2\2\2\64\66\5\4\3\2\65\64\3\2\2\2\669\3\2\2\2\67\65\3\2\2\2\678\3\2"+
		"\2\28:\3\2\2\29\67\3\2\2\2:;\7\2\2\3;\3\3\2\2\2<>\5\6\4\2=?\7)\2\2>=\3"+
		"\2\2\2>?\3\2\2\2?O\3\2\2\2@B\5\f\7\2AC\7)\2\2BA\3\2\2\2BC\3\2\2\2CO\3"+
		"\2\2\2DF\5\20\t\2EG\7)\2\2FE\3\2\2\2FG\3\2\2\2GO\3\2\2\2HJ\5\24\13\2I"+
		"K\7)\2\2JI\3\2\2\2JK\3\2\2\2KO\3\2\2\2LO\5\22\n\2MO\7)\2\2N<\3\2\2\2N"+
		"@\3\2\2\2ND\3\2\2\2NH\3\2\2\2NL\3\2\2\2NM\3\2\2\2O\5\3\2\2\2PQ\7\63\2"+
		"\2QR\7(\2\2RS\5\b\5\2ST\7\37\2\2TU\5\24\13\2Ue\3\2\2\2VW\7\63\2\2WY\7"+
		"(\2\2XZ\5\b\5\2YX\3\2\2\2YZ\3\2\2\2Z\\\3\2\2\2[]\5\n\6\2\\[\3\2\2\2\\"+
		"]\3\2\2\2]_\3\2\2\2^`\5\22\n\2_^\3\2\2\2_`\3\2\2\2`e\3\2\2\2ab\7\63\2"+
		"\2bc\7(\2\2ce\5\b\5\2dP\3\2\2\2dV\3\2\2\2da\3\2\2\2e\7\3\2\2\2fk\7\63"+
		"\2\2gh\7+\2\2hj\7\63\2\2ig\3\2\2\2jm\3\2\2\2ki\3\2\2\2kl\3\2\2\2l\t\3"+
		"\2\2\2mk\3\2\2\2nw\7\"\2\2ot\7\63\2\2pq\7*\2\2qs\7\63\2\2rp\3\2\2\2sv"+
		"\3\2\2\2tr\3\2\2\2tu\3\2\2\2ux\3\2\2\2vt\3\2\2\2wo\3\2\2\2wx\3\2\2\2x"+
		"y\3\2\2\2yz\7#\2\2z\13\3\2\2\2{|\5\16\b\2|}\7\37\2\2}~\5\24\13\2~\u0088"+
		"\3\2\2\2\177\u0080\5\16\b\2\u0080\u0081\7\21\2\2\u0081\u0082\5\24\13\2"+
		"\u0082\u0088\3\2\2\2\u0083\u0084\5\16\b\2\u0084\u0085\7\22\2\2\u0085\u0086"+
		"\5\24\13\2\u0086\u0088\3\2\2\2\u0087{\3\2\2\2\u0087\177\3\2\2\2\u0087"+
		"\u0083\3\2\2\2\u0088\r\3\2\2\2\u0089\u0092\7\63\2\2\u008a\u008b\7+\2\2"+
		"\u008b\u0091\7\63\2\2\u008c\u008d\7&\2\2\u008d\u008e\5\24\13\2\u008e\u008f"+
		"\7\'\2\2\u008f\u0091\3\2\2\2\u0090\u008a\3\2\2\2\u0090\u008c\3\2\2\2\u0091"+
		"\u0094\3\2\2\2\u0092\u0090\3\2\2\2\u0092\u0093\3\2\2\2\u0093\17\3\2\2"+
		"\2\u0094\u0092\3\2\2\2\u0095\u0096\7\37\2\2\u0096\u0097\5\24\13\2\u0097"+
		"\21\3\2\2\2\u0098\u009c\7$\2\2\u0099\u009b\5\4\3\2\u009a\u0099\3\2\2\2"+
		"\u009b\u009e\3\2\2\2\u009c\u009a\3\2\2\2\u009c\u009d\3\2\2\2\u009d\u009f"+
		"\3\2\2\2\u009e\u009c\3\2\2\2\u009f\u00a0\7%\2\2\u00a0\23\3\2\2\2\u00a1"+
		"\u00a2\5\26\f\2\u00a2\25\3\2\2\2\u00a3\u00a8\5\30\r\2\u00a4\u00a5\t\2"+
		"\2\2\u00a5\u00a7\5\30\r\2\u00a6\u00a4\3\2\2\2\u00a7\u00aa\3\2\2\2\u00a8"+
		"\u00a6\3\2\2\2\u00a8\u00a9\3\2\2\2\u00a9\27\3\2\2\2\u00aa\u00a8\3\2\2"+
		"\2\u00ab\u00b0\5\32\16\2\u00ac\u00ad\t\3\2\2\u00ad\u00af\5\32\16\2\u00ae"+
		"\u00ac\3\2\2\2\u00af\u00b2\3\2\2\2\u00b0\u00ae\3\2\2\2\u00b0\u00b1\3\2"+
		"\2\2\u00b1\31\3\2\2\2\u00b2\u00b0\3\2\2\2\u00b3\u00b8\5\34\17\2\u00b4"+
		"\u00b5\t\4\2\2\u00b5\u00b7\5\34\17\2\u00b6\u00b4\3\2\2\2\u00b7\u00ba\3"+
		"\2\2\2\u00b8\u00b6\3\2\2\2\u00b8\u00b9\3\2\2\2\u00b9\33\3\2\2\2\u00ba"+
		"\u00b8\3\2\2\2\u00bb\u00be\5\36\20\2\u00bc\u00bd\7\n\2\2\u00bd\u00bf\5"+
		"\36\20\2\u00be\u00bc\3\2\2\2\u00be\u00bf\3\2\2\2\u00bf\35\3\2\2\2\u00c0"+
		"\u00c5\5 \21\2\u00c1\u00c2\t\5\2\2\u00c2\u00c4\5 \21\2\u00c3\u00c1\3\2"+
		"\2\2\u00c4\u00c7\3\2\2\2\u00c5\u00c3\3\2\2\2\u00c5\u00c6\3\2\2\2\u00c6"+
		"\37\3\2\2\2\u00c7\u00c5\3\2\2\2\u00c8\u00cd\5\"\22\2\u00c9\u00ca\t\6\2"+
		"\2\u00ca\u00cc\5\"\22\2\u00cb\u00c9\3\2\2\2\u00cc\u00cf\3\2\2\2\u00cd"+
		"\u00cb\3\2\2\2\u00cd\u00ce\3\2\2\2\u00ce!\3\2\2\2\u00cf\u00cd\3\2\2\2"+
		"\u00d0\u00d3\5$\23\2\u00d1\u00d2\7\30\2\2\u00d2\u00d4\5\"\22\2\u00d3\u00d1"+
		"\3\2\2\2\u00d3\u00d4\3\2\2\2\u00d4#\3\2\2\2\u00d5\u00d6\7\25\2\2\u00d6"+
		"\u00e3\5$\23\2\u00d7\u00d8\7\24\2\2\u00d8\u00e3\5$\23\2\u00d9\u00da\7"+
		"\34\2\2\u00da\u00e3\5$\23\2\u00db\u00dc\7\5\2\2\u00dc\u00e3\5$\23\2\u00dd"+
		"\u00de\7\17\2\2\u00de\u00e3\5\16\b\2\u00df\u00e0\7\20\2\2\u00e0\u00e3"+
		"\5\16\b\2\u00e1\u00e3\5&\24\2\u00e2\u00d5\3\2\2\2\u00e2\u00d7\3\2\2\2"+
		"\u00e2\u00d9\3\2\2\2\u00e2\u00db\3\2\2\2\u00e2\u00dd\3\2\2\2\u00e2\u00df"+
		"\3\2\2\2\u00e2\u00e1\3\2\2\2\u00e3%\3\2\2\2\u00e4\u00e8\5.\30\2\u00e5"+
		"\u00e7\5(\25\2\u00e6\u00e5\3\2\2\2\u00e7\u00ea\3\2\2\2\u00e8\u00e6\3\2"+
		"\2\2\u00e8\u00e9\3\2\2\2\u00e9\'\3\2\2\2\u00ea\u00e8\3\2\2\2\u00eb\u00ec"+
		"\7+\2\2\u00ec\u00fb\7\63\2\2\u00ed\u00ee\7&\2\2\u00ee\u00ef\5\24\13\2"+
		"\u00ef\u00f0\7\'\2\2\u00f0\u00fb\3\2\2\2\u00f1\u00f3\5*\26\2\u00f2\u00f4"+
		"\5\22\n\2\u00f3\u00f2\3\2\2\2\u00f3\u00f4\3\2\2\2\u00f4\u00fb\3\2\2\2"+
		"\u00f5\u00fb\5,\27\2\u00f6\u00fb\5\22\n\2\u00f7\u00fb\7\31\2\2\u00f8\u00fb"+
		"\7\17\2\2\u00f9\u00fb\7\20\2\2\u00fa\u00eb\3\2\2\2\u00fa\u00ed\3\2\2\2"+
		"\u00fa\u00f1\3\2\2\2\u00fa\u00f5\3\2\2\2\u00fa\u00f6\3\2\2\2\u00fa\u00f7"+
		"\3\2\2\2\u00fa\u00f8\3\2\2\2\u00fa\u00f9\3\2\2\2\u00fb)\3\2\2\2\u00fc"+
		"\u0105\7\"\2\2\u00fd\u0102\5\24\13\2\u00fe\u00ff\7*\2\2\u00ff\u0101\5"+
		"\24\13\2\u0100\u00fe\3\2\2\2\u0101\u0104\3\2\2\2\u0102\u0100\3\2\2\2\u0102"+
		"\u0103\3\2\2\2\u0103\u0106\3\2\2\2\u0104\u0102\3\2\2\2\u0105\u00fd\3\2"+
		"\2\2\u0105\u0106\3\2\2\2\u0106\u0107\3\2\2\2\u0107\u0108\7#\2\2\u0108"+
		"+\3\2\2\2\u0109\u010b\7\63\2\2\u010a\u010c\5*\26\2\u010b\u010a\3\2\2\2"+
		"\u010b\u010c\3\2\2\2\u010c\u010d\3\2\2\2\u010d\u010e\5\22\n\2\u010e-\3"+
		"\2\2\2\u010f\u0120\5\60\31\2\u0110\u0120\7\7\2\2\u0111\u0120\7\b\2\2\u0112"+
		"\u0120\7\63\2\2\u0113\u0114\7\"\2\2\u0114\u0115\5\24\13\2\u0115\u0116"+
		"\7#\2\2\u0116\u0120\3\2\2\2\u0117\u0120\5\22\n\2\u0118\u0119\7\35\2\2"+
		"\u0119\u0120\7\63\2\2\u011a\u011b\7\t\2\2\u011b\u0120\7\63\2\2\u011c\u011d"+
		"\7\36\2\2\u011d\u0120\5\24\13\2\u011e\u0120\5\62\32\2\u011f\u010f\3\2"+
		"\2\2\u011f\u0110\3\2\2\2\u011f\u0111\3\2\2\2\u011f\u0112\3\2\2\2\u011f"+
		"\u0113\3\2\2\2\u011f\u0117\3\2\2\2\u011f\u0118\3\2\2\2\u011f\u011a\3\2"+
		"\2\2\u011f\u011c\3\2\2\2\u011f\u011e\3\2\2\2\u0120/\3\2\2\2\u0121\u0122"+
		"\t\7\2\2\u0122\61\3\2\2\2\u0123\u012c\7&\2\2\u0124\u0129\5\24\13\2\u0125"+
		"\u0126\7*\2\2\u0126\u0128\5\24\13\2\u0127\u0125\3\2\2\2\u0128\u012b\3"+
		"\2\2\2\u0129\u0127\3\2\2\2\u0129\u012a\3\2\2\2\u012a\u012d\3\2\2\2\u012b"+
		"\u0129\3\2\2\2\u012c\u0124\3\2\2\2\u012c\u012d\3\2\2\2\u012d\u012e\3\2"+
		"\2\2\u012e\u012f\7\'\2\2\u012f\63\3\2\2\2$\67>BFJNY\\_dktw\u0087\u0090"+
		"\u0092\u009c\u00a8\u00b0\u00b8\u00be\u00c5\u00cd\u00d3\u00e2\u00e8\u00f3"+
		"\u00fa\u0102\u0105\u010b\u011f\u0129\u012c";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}