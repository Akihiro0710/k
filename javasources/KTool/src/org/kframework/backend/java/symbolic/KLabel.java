package org.kframework.backend.java.symbolic;


import org.kframework.kil.ASTNode;

/**
 * Created with IntelliJ IDEA.
 * User: andrei
 * Date: 3/18/13
 * Time: 12:20 PM
 * To change this template use File | Settings | File Templates.
 */
public abstract class KLabel extends Term {

    protected KLabel() {
        super("KLabel");
    }

    @Override
    public boolean isSymbolic() {
        return false;
    }

    public abstract boolean isConstructor();

    public abstract boolean isFunction();

    @Override
    public void accept(Visitor visitor) {
        visitor.visit(this);
    }

    @Override
    public ASTNode accept(Transformer transformer) {
        return transformer.transform(this);
    }

}
